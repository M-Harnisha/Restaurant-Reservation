class MenuItemsController < ApplicationController
     def create 
        @restaurant = Restaurant.find(params[:restaurant_id])
        @menu_item = @restaurant.menu_items.create(menu_params)
        redirect_to @restaurant
    end 

    def edit 
        @restaurant = Restaurant.find(params[:id])
        @menu_item= MenuItem.find(params[:restaurant_id])
    end

    def update
        @restaurant = Restaurant.find(params[:restaurant_id])
        @menu_item= @restaurant.menu_items.find(params[:id])
        if @menu_item.update(menu_params)
            redirect_to @restaurant
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @restaurant = Restaurant.find(params[:id])
        @menu_item = @restaurant.menu_items.find(params[:restaurant_id])
        @menu_item.destroy
        redirect_to @restaurant  
    end

    private
    def menu_params
        params.require(:menu_item).permit(:name,:quantity,:rate,:images)
    end
    
end
