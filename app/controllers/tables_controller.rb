class TablesController < ApplicationController

    def create 
        @restaurant = Restaurant.find(params[:restaurant_id])
        @table = @restaurant.tables.create(table_params)
        redirect_to @restaurant
    end 

    def edit 
        @restaurant = Restaurant.find(params[:id])
        @table= Table.find(params[:restaurant_id])
    end

    def update
        @restaurant = Restaurant.find(params[:restaurant_id])
        @table = @restaurant.tables.find(params[:id])
        if @table.update(table_params)
            redirect_to @restaurant
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @restaurant = Restaurant.find(params[:id])
        @table = @restaurant.tables.find(params[:restaurant_id])
        @table.destroy
        redirect_to @restaurant  
    end

    private
    def table_params
        params.require(:table).permit(:name,:member,:booked)
    end
end
