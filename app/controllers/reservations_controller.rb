class ReservationsController < ApplicationController

    def index
        @value = params.require(:reservation)
        puts @value
        @restaurant = Restaurant.find(params[:id])
        if @value=="Table"
            redirect_to reservation_table_path(id:params[:id],type:"table") 
        elsif @value=="Food"
            redirect_to reservation_food_path(id:params[:id])
        else
            redirect_to reservation_table_path(id:params[:id],type:"table_food") 
        end
    end

   
end
