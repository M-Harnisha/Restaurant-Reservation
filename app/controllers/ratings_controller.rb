class RatingsController < ApplicationController

    def new
        @restaurant = Restaurant.find(params[:restaurant_id])
        @reservation = Reservation.find(params[:id])
    end

    def create
        @restaurant = Restaurant.find(params[:restaurant_id])
        @reservation = Reservation.find(params[:id])
        @restaurant.ratings.create(value:params.require(@restaurant.id.to_s))
        @reservation.order.order_items.each do |item|
            @menu = MenuItem.find(item.menu_id)
            @menu.ratings.create(value:params.require(@menu.id.to_s))
        end
        redirect_to reservation_show_url(id:@restaurant)
    end
end