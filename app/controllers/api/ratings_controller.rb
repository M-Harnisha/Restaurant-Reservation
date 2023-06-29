class Api::RatingsController < Api::ApiController

    before_action :is_user_order , only: [:new,:create]

    def create
        restaurant = Restaurant.find_by(id: params[:id])
        if restaurant
            restaurant.ratings.create(value:params.require(restaurant.id.to_s))          
        else
            render json: {message:"No restaurant is found with this id #{params[:id]}"}, status: :not_found
            return
        end
        reservation = Reservation.find_by(id: params[:reservation_id])
        reservation.order.order_items.each do |item|
            menu = MenuItem.find_by(id: item.menu_id)
            menu.ratings.create(value:params.require(menu.id.to_s))
        end
        render json: {message:"New rating is created"} , status: :created
        return
    end

    private 
 
     def is_user_order
         reservation = Reservation.find_by(id: params[:reservation_id])
         if reservation
            unless  current_account and current_account.accountable_type=="User" and current_account.accountable_id==reservation.user_id
                if current_account
                    render json:{message: "You are not authorized !" } , status: :forbidden
                else
                    render json:{message: "You are not authorized !" } , status: :unauthorized 
                end
            end
        else
            render json: {message:"No reservation is found with id #{params[:reservation_id]}"}  ,status: :not_found
        end
     end
end