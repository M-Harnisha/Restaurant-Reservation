class RatingsController < ApplicationController

    def new
        @restaurant = Restaurant.find(params[:id])
        @reservation = Reservation.find(params[:reservation_id])
    end

    def create
        @restaurant = Restaurant.find(params[:id])
        @reservation = Reservation.find(params[:reservation_id])
        @restaurant.ratings.create(value:params.require(@restaurant.id.to_s))
        @reservation.order.order_items.each do |item|
            @menu = MenuItem.find(item.menu_id)
            @menu.ratings.create(value:params.require(@menu.id.to_s))
        end
        redirect_to reservation_show_path(id:@restaurant)
    end
end