class Api::OrdersController < Api::ApiController

    before_action :is_user , only: [:food,:confrim,:show,:edit,:update,:destroy]

    before_action :is_user_order , only: [:edit,:update,:destroy]


    def food
        restaurant = Restaurant.find_by(id: params[:id])
        if restaurant
            menus = restaurant.menu_items
            reservation = params[:reservation_id]
            if menus.length!=0
                render json: menus , status: :ok
            else
                render json: {message:"No menu items for this restaurant"},status: :no_content
            end
        else
            render json: {message:"No restaurant id found with id #{params[:id]}"},status: :not_found
        end
    end


    def confrim
        restaurant = Restaurant.find_by(id: params[:id])
        if restaurant
            menus = restaurant.menu_items
            total_rate = 0
            reservationId = params[:reservation_id]
            puts reservationId
            if reservationId=="nil"
                reservation = restaurant.reservations.new(user_id:12,date:Date.today)
                reservation.save
            else
                reservation = Reservation.find_by(id: reservationId)
            end
            if reservation
                food  = reservation.create_order(rate:0)
                food.save

                if menus
                    menus.each do |menu|
                        puts menu.id
                        menuId = menu.id.to_s
                        if params.has_key?(menuId)
                            quantity = params.require(:quantity)
                            if quantity[menuId].length!=0
                                order_food = food.order_items.create(menu_id: menu.id,quantity: quantity[menuId].to_i,rate: menu.rate,name:menu.name)
                                order_food.save
                                q = menu.quantity
                                menu.update(quantity:q-quantity[menuId].to_i)
                                total_rate = total_rate + (quantity[menuId].to_i*menu.rate)
                            end
                        end
                    end
                    if total_rate==0 && reservationId=="nil"
                        if reservation.destroy
                            render json: {message:"No order is selected"} , status: :unprocessable_entity
                        else
                            render json: {message:reservation.errors.full_messages}, status: :unprocessable_entity
                        end
                    elsif total_rate==0
                        if food.destroy
                            render json: {message:"No order is selected"} , status: :unprocessable_entity
                        else
                            render json: {message:food.errors.full_messages}, status: :unprocessable_entity
                        end
                    else
                        if food.update(rate:total_rate)
                            food.save
                            render json: food , status: :ok
                        else
                            render json: {message:food.errors.full_messages}, status: :unprocessable_entity
                        end
                    end
                else
                    render json: {message:"Can't get menus"}, status: :no_content
                end

            else
                render json: {message:"Can't get reservation  "},status: :not_found
            end
        else
            render json: {message:"Can't get restaurant "}, status: :not_found
        end
    end

    def destroy
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation
            orders = reservation.order.order_items
            if orders
            orders.each do |order|
                menu = MenuItem.find_by(id: order.menu_id)
                if menu
                    q = menu.quantity + order.quantity
                    if menu.update(quantity:q)
                        menu.save
                        if reservation.order && reservation.tables.length!=0
                            food = reservation.order
                            if food.destroy
                                render json: food , status: :see_other
                            else
                                render json: {message:food.errors.full_messages}, status: :unprocessable_entity
                            end
                        else
                            if reservation.destroy
                                render json: reservation , status: :see_other
                            else
                                render json: {message:reservation.errors.full_messages}, status: :unprocessable_entity
                            end
                        end
                    else
                        render json: {message:menu.errors.full_messages}, status: :unprocessable_entity
                    end
                else
                    render json: {message:"Can't get menu"}, status: :not_found
                end
            end
            else
                render json: {message:"Can't get orders"}, status: :no_content
            end
        else
            render json: {message:"Can't get reservation"}, status: :not_found
        end
    end

	
    def highest_item
        order = Order.joins(:order_items)
                .group('orders.id')
                .order('COUNT(order_items.id) DESC')
                .first
        if order 
            render json: order , status: :ok
        else 
            render json: {message:"No order available"} , status: :not_found
        end
    end

    private 
    def is_user
        unless current_account and current_account.accountable_type == "User"
            if current_account
                render json:{message: "You are not authorized !" } , status: :forbidden 
            else
                render json:{message: "You are not singed in  !" } , status: :unauthorized 
            end
        end
   end

    def is_user_order
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation
            unless account_signed_in? and current_account.accountable_type=="User" and current_account.accountable_id==reservation.user_id
                render json:{message: "You are not authorized !" } , status: :forbidden   
            end
        else
            render json: {message:"No reservation is found with id #{params[:reservation_id]}"} , status: :not_found
        end
    end

end
