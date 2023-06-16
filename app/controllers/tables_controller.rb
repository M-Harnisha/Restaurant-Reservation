class TablesController < ApplicationController

    before_action :is_restaurant_owner , only: [:create,:edit,:update,:destroy]
   
    def create 
        @restaurant = Restaurant.find(params[:restaurant_id])
        @table = @restaurant.tables.create(table_params)
        redirect_to @restaurant
    end 

    def edit 
        @restaurant = Restaurant.find(params[:restaurant_id])
        @table= Table.find(params[:id])
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
        @restaurant = Restaurant.find(params[:restaurant_id])
        @table = @restaurant.tables.find(params[:id])
        @table.destroy
        redirect_to @restaurant  
    end

    private
    def table_params
        params.require(:table).permit(:name,:member)
    end

    
    def is_restaurant_owner 
        @restaurant = Restaurant.find(params[:restaurant_id])
        unless account_signed_in? and current_account.accountable_type=="Owner" and current_account.accountable_id==@restaurant.owner_id
            flash[:notice] = "Owner permissions only!!"
            redirect_to root_path
        end
    end
end
