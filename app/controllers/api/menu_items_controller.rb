class Api::MenuItemsController < Api::ApiController

    before_action :is_restaurant_owner , only: [:create,:edit,:update,:destroy]

    def create
        restaurant = Restaurant.find_by(id: params[:restaurant_id])
        if restaurant
            menu_item = restaurant.menu_items.create(menu_params)
            if menu_item.save
                render json: menu_item , status: :created
            else
                render json: {message:menu_item.errors} , status: :unprocessable_entity
            end
        else
            render json: {message:"No restaurant is found with id #{params[:restaurant_id]}"},status: :not_found
        end
    end


    def update

        restaurant = Restaurant.find_by(id: params[:restaurant_id])

        if restaurant

            menu_item= restaurant.menu_items.find_by(id: params[:id])
            if menu_item
                menu_item.update(menu_params)
                if menu_item.save
                    render json: menu_item , status: :ok
                else
                    render json: {message:menu_item.errors.full_messages} , status: :unprocessable_entity
                end
            else
                render json: {message:"No menu item is found with id #{params[:id]}"} , status: :not_found
            end

        else

            render json: {message:"No restaurant is found  with id #{params[:restaurant_id]}"} , status: :not_found

        end

    end

    def destroy

        restaurant = Restaurant.find_by(id: params[:restaurant_id])

        if restaurant

            menu_item = restaurant.menu_items.find_by(id: params[:id])

            if menu_item
                if menu_item.destroy
                    render json: {message: "Menu item was deleted successfully"} , status: :see_other
                else
                    render json: {message:menu_item.errors.full_messages} , status: :unprocessable_entity
                end
            else
                render json: {message:"Can't find menu item with id #{params[:id]}"} , status: :not_found
            end

        else
           render json: {message:"Can't find restaurant with id #{params[:restaurant_id]}"} , status: :not_found
         end

    end

    private
    def menu_params
        params.require(:menu_item).permit(:name,:quantity,:rate,:images)
    end

    def is_restaurant_owner
        restaurant = Restaurant.find_by(id: params[:restaurant_id])
        if restaurant
            unless current_account and current_account.accountable_type=="Owner" and current_account.accountable_id==restaurant.owner_id
                if current_account
                    render json:{message: "You are not authorized !" } , status: :forbidden
                else
                    render json:{message: "You are not signed in !" } , status: :unauthorized
                end
            end
        else
            render json: {message:"No restaurant is found with id #{params[:restaurant_id]}"} , status: :not_found
        end
    end
end
