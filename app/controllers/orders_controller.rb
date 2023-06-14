class OrdersController < ApplicationController

    def food
        @restaurant = Restaurant.find(params[:id])
        @menus = @restaurant.menu_items
        @reservation = params[:reservation_id]
    end

    def confrim
        @restaurant = Restaurant.find(params[:id])
        @menus = @restaurant.menu_items
        if params[:reservation_id]=nil
            @reservation = @restaurant.reservations.new(user_id:1,date:Date.today)
        else 
            @reservation = Reservation.find(params[:reservation_id])
        end
        @total_rate = 0
        if @reservation.save
            @food  = @reservation.create_order(rate:0) 
            @food.save
            @menus.each do |menu|
                puts menu.id
                menuId = menu.id.to_s
                if params.has_key?(menuId)
                    @quantity = params.require(:quantity)
                    @order_food = @food.order_items.create(menu_id: menu.id,quantity: @quantity[menuId].to_i,rate: menu.rate,name:menu.name)
                    @order_food.save
                    q = menu.quantity
                    menu.update(quantity:q-@quantity[menuId].to_i)
                    @total_rate = @total_rate + (@quantity[menuId].to_i*menu.rate)
                end
            end
            @food.update(rate:@total_rate)
            @food.save
            redirect_to reservation_rating_new_path(restaurant_id:@restaurant.id,id:@reservation.id)
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
        @reservation = Reservation.find(params[:id])
        @reservation.destroy
        redirect_to root_path, status: :see_other
    end

end
