class MenuItemsController < ApplicationController

    before_action :is_restaurant 
    before_action :is_restaurant_owner , only: [:create,:edit,:update,:destroy]

    def create 
        @menu_item = @restaurant.menu_items.create(menu_params)
        if @menu_item.save
            redirect_to @restaurant , notice:"New menu item is created"
        else 
            redirect_to root_path
        end
    end 

    def edit 
        if @menu_item= MenuItem.find_by(id: params[:id])
            @menu_item
        else
            redirect_to @restaurant , notice:"Not found!.."
        end
    end

    def update
        if @menu_item= @restaurant.menu_items.find_by(id: params[:id]) and @menu_item.update(menu_params)
            redirect_to @restaurant , notice:"Updated successfully"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        if @menu_item = @restaurant.menu_items.find_by(id: params[:id])
            @menu_item.destroy
            redirect_to @restaurant  , notice:"Destroyed successfully"
        else
            redirect_to @restaurant , notice:"Not found!.."
        end
    end

    private
    def menu_params
        params.require(:menu_item).permit(:name,:quantity,:rate,:images)
    end
    
    def is_restaurant_owner 
        @restaurant = Restaurant.find_by(id: params[:restaurant_id])
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
