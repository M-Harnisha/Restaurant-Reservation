class ReservationsController < ApplicationController

    before_action :is_user , only: [:index]

    def index
        @value = params.require(:reservation)
        puts @value
        @restaurant = Restaurant.find(params[:id])
        if @value=="Table"
            redirect_to reservation_table_path(id:params[:id],type:"table") 
        elsif @value=="Food"
            redirect_to reservation_food_path(id:params[:id],reservation_id:"nil")
        else
            redirect_to reservation_table_path(id:params[:id],type:"table_food") 
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
