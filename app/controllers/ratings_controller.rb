class RatingsController < ApplicationController

    before_action :is_reservation_user 
    
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
        redirect_to reservation_show_path 
    end

    private
    def is_reservation_user
        if @restaurant = Restaurant.find_by(id: params[:id]) and @reservation = Reservation.find_by(id: params[:reservation_id])
            unless account_signed_in? and current_account.accountable_type=="User" and current_account.accountable_id==@reservation.user_id
                if account_signed_in?
                    flash[:notice] = "User permissions only!!"
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