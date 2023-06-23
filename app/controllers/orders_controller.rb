class OrdersController < ApplicationController

    before_action :is_user , only: [:table,:confrim,:show,:edit,:update,:destroy]

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
        puts reservationId
        if reservationId=="nil"
            @reservation = @restaurant.reservations.new(user_id:current_account.accountable_id,date:Date.today)
            @reservation.save
        else 
            @reservation = Reservation.find(reservationId)
        end

            @food  = @reservation.create_order(rate:0) 
            @food.save
            @menus.each do |menu|
                puts menu.id
                menuId = menu.id.to_s
                if params.has_key?(menuId)
                    quantity = params.require(:quantity)
                    if quantity[menuId].length!=0
                        @order_food = @food.order_items.create(menu_id: menu.id,quantity: quantity[menuId].to_i,rate: menu.rate,name:menu.name)
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
                @food.destroy
                redirect_to reservation_food_path(id:@restaurant,reservation_id:reservationId) ,  notice: "Enter details correctly"
            else
                @food.update(rate:total_rate)
                @food.save
            redirect_to reservation_rating_new_path(id:@restaurant.id,reservation_id:@reservation.id)

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
        puts " ``````````````````````````````````dgdgg`````````````````````````````````````````````````"
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
        
        redirect_to root_path, status: :see_other
    end

    private 
   def is_user
        unless account_signed_in? and current_account.accountable_type=="User"
            flash[:notice] = "User permissions only!!"
            if account_signed_in? 
                redirect_to root_path
            else 
                redirect_to new_account_session_path
            end
        end
   end

    def is_user_order
        @reservation = Reservation.find(params[:reservation_id])
        unless account_signed_in? and current_account.accountable_type=="User" and current_account.accountable_id==@reservation.user_id
            flash[:notice] = "only booked user can make changes!"
            redirect_to root_path
        end
    end

end
