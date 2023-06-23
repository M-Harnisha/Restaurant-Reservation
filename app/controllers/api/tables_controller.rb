class Api::TablesController < Api::ApiController

    before_action :is_restaurant_owner , only: [:create,:edit,:update,:destroy]
   
    def create 
        restaurant = Restaurant.find_by(id: params[:restaurant_id])
        if restaurant 
            table = restaurant.tables.create(table_params)
            if table.save
                render json: table , status: :created
            else
                render json: {errors: table.errors.full_messages} , status: :unprocessable_entity
            end
        else
            render json: {message:"No restaurant is found with id #{params[:restaurant_id]}"} , status: :not_found
        end
    end 

    def edit 
        restaurant = Restaurant.find_by(id: params[:restaurant_id])
        if restaurant 
            table= Table.find_by(id: params[:id])
            if table 
                render json: table , status: :ok
            else
                render json: {message:"No table is found with id #{params[:id]}"} , status: :not_found
            end
        else
            render json: {message:"No restaurant is found with id #{params[:restaurant_id]}"} , status: :not_found

        end

    end

    def update
        table =Table.find_by(id: params[:id])
        if table
            
            table.update(table_params)

            if table.save
                render json: table , status: :ok
            else
                render json: {errors: table.errors.full_messages} , status: :unprocessable_entity
            end
        else
            render json: {message:"No table is found with this id #{params[:id]}"} , status: :not_found
        end
    end

    def destroy
        table = Table.find_by(id: params[:id])
        if table
            if table.destroy
            render json: {message:"Table is destroyed successfully"} , status: :see_other
            else
                render json: {errors: table.errors.full_messages} , status: :unprocessable_entity
            end
        else
            render json: {message:"No table is found with this id #{params[:id]}"} , status: :not_found
        end
    end

    private
    def table_params
        params.require(:table).permit(:name,:member)
    end

    
    def is_restaurant_owner 
        restaurant = Restaurant.find_by(id: params[:restaurant_id])
        if restaurant
            unless current_account and current_account.accountable_type=="Owner" and current_account.accountable_id==restaurant.owner_id
                render json:{message: "You are not authorized !" } , status: :unauthorized 
            end
        else
            render json: {message:"No restaurant is found with id #{params[:restaurant_id]}"} , status: :not_found
        end
    end
end
