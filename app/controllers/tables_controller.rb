class TablesController < ApplicationController

    before_action :is_restaurant
    before_action :is_restaurant_owner , only: [:create,:edit,:update,:destroy]
   
    def create 
        @table = @restaurant.tables.create(table_params)
        if @table.save
            redirect_to @restaurant , notice:"New table is created"
        else 
            redirect_to root_path
        end
    end 

    def edit 
        if @table= Table.find_by(id: params[:id])
            @table
        else
            redirect_to @restaurant , notice:"Not found!.."
        end
    end

    def update
        if @table = @restaurant.tables.find_by(id: params[:id]) and @table.update(table_params)
            redirect_to @restaurant , notice:"Updated successfully"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        if @table = @restaurant.tables.find_by(id: params[:id])
            @table.destroy
            redirect_to @restaurant  , notice:"Destroyed successfully"
        else
            redirect_to @restaurant , notice:"Not found!.."
        end
    end

    private
    def table_params
        params.require(:table).permit(:name,:member)
    end

    
    def is_restaurant_owner 
        unless account_signed_in? and current_account.accountable_type=="Owner" and current_account.accountable_id==@restaurant.owner_id
            if account_signed_in?
                flash[:notice] = "Owner permissions only!!"
                redirect_to root_path
            else
                redirect_to new_account_session_path
            end
        end
    end

    def is_restaurant
        if @restaurant = Restaurant.find_by(id: params[:restaurant_id])
          @restaurant
        else
          redirect_to root_path , notice:"No restaurant is available with given id"
        end
    end
end
