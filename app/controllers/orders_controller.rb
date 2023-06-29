class OrdersController < ApplicationController

    before_action :is_user , only: [:food,:confrim]

    before_action :is_user_order , only: [:edit,:update,:destroy]


    def food
        @restaurant = Restaurant.find(params[:id])
        @menus = @restaurant.menu_items
        @reservation = params[:reservation_id]
    end


    def confrim
        @restaurant = Restaurant.find(params[:id])
        @menus = @restaurant.menu_items
        
        total_rate = 0
        reservationId = params[:reservation_id]
        if reservationId=="nil"
            @reservation = @restaurant.reservations.new(user_id:current_account.accountable_id,date:Date.today)
            @reservation.save
        else 
            @reservation = Reservation.find_by(id: reservationId)
        end
           
            food = Order.new(rate:0,reservation:@reservation)
            food.save
            @menus.each do |menu|
                 
                menuId = menu.id.to_s
                if params.has_key?(menuId)
                    quantity = params.require(:quantity)
                    if quantity[menuId].length!=0
                        @order_food =OrderItem.new(menu_id: menu.id,quantity: quantity[menuId].to_i,rate: menu.rate,name:menu.name,order:food)
                        @order_food.save
                        q = menu.quantity
                        menu.update(quantity:q-quantity[menuId].to_i)
                        total_rate = total_rate + (quantity[menuId].to_i*menu.rate)
                    end
                end
            end
            if total_rate==0 && reservationId=="nil"
                @reservation.destroy
                redirect_to reservation_food_path(id:@restaurant,reservation_id:"nil"),  notice: "Enter details correctly"
            elsif total_rate==0
                food.destroy
                redirect_to reservation_food_path(id:@restaurant,reservation_id:reservationId) ,  notice: "Enter details correctly"
            else
                food.update(rate:total_rate)
                food.save
            redirect_to reservation_rating_new_path(id:@restaurant.id,reservation_id:@reservation.id) , notice:"Order placed successfully"
            end
    end

    def edit 
        @restaurant = Restaurant.find(params[:id])
        @menus = @restaurant.menu_items
        @reservation = Reservation.find(params[:reservation_id])
        @order = @reservation.order
        @foods = @order.order_items
    end


    def destroy
        @reservation = Reservation.find(params[:reservation_id])
        @orders = @reservation.order.order_items
        @orders.each do |order|
            @menu = MenuItem.find(order.menu_id)
            q = @menu.quantity + order.quantity
            @menu.update(quantity:q)
            @menu.save
        end

        if @reservation.order && @reservation.tables.length!=0
            @food = @reservation.order
            @food.destroy
        else
            @reservation.destroy
        end
        
        redirect_to root_path, status: :see_other , notice:"Deleted successfully"
    end

    private 
   def is_user
    if @restaurant = Restaurant.find_by(id: params[:id]) and (@reservation = Reservation.find_by(id: params[:reservation_id]) or params[:reservation_id]=='nil')
        unless account_signed_in? and current_account.accountable_type=="User"
            flash[:notice] = "User permissions only!!"
            if account_signed_in? 
                redirect_to root_path
            else 
                redirect_to new_account_session_path
            end
        end
    else
        flash[:notice] = "Not found!.."
        redirect_to root_path
    end
   end

    def is_user_order
        if @restaurant = Restaurant.find_by(id: params[:id]) and @reservation = Reservation.find_by(id: params[:reservation_id])
            unless account_signed_in? and current_account.accountable_type=="User" and current_account.accountable_id==@reservation.user_id
                if account_signed_in?
                    flash[:notice] = "only booked user can make changes!"
                    redirect_to root_path
                else
                    redirect_to new_account_session_path
                end
            end
        else
            flash[:notice] = "Not found!.."
            redirect_to root_path
        end
    end

end
