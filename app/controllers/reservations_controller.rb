class ReservationsController < ApplicationController

    before_action :is_user , only: [:index]

    def index
        value = params.require(:reservation)
        
        @restaurant = Restaurant.find(params[:id])
        if value=="Table"
            if @restaurant.tables.length==0 
                redirect_to restaurant_path , notice:"No tables available..!"
            else
                redirect_to reservation_table_path(id:params[:id],type:"table") 
            end
        elsif value=="Food"
            if @restaurant.menu_items.length==0 
                redirect_to restaurant_path , notice:"No menu items available..!"
            else
                redirect_to reservation_food_path(id:params[:id],reservation_id:"nil")
            end
        else
            if @restaurant.tables.length==0 
                redirect_to restaurant_path , notice:"No tables available..!"
            elsif @restaurant.menu_items.length==0 
                redirect_to restaurant_path , notice:"No menu items available..!"
            else
                redirect_to reservation_table_path(id:params[:id],type:"table_food") 
            end 
        end
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
end
