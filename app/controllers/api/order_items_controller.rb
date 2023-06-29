class Api::OrderItemsController < Api::ApiController
    before_action :is_user_order , only: [:new,:destroy]

    def destroy
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation
            order_item = OrderItem.find_by(id: params[:order_item_id])
            if order_item
                menu  = MenuItem.find_by(id: order_item.menu_id)
                if menu
                    available_quantity = menu.quantity + order_item.quantity
                    menu.update(quantity:available_quantity)
                    if menu.save
                        order_item.destroy
                        if reservation.order.order_items.length == 0
                            if reservation.tables.length!=0
                                if reservation.order.destroy
                                    render json: { message: "Order was successfully destroyed"}  , status: :see_other
                                else
                                    render json: { errors: reservation.order.errors.full_messages}, status: :unprocessable_entity
                                end
                            else
                                if reservation.destroy
                                    render json: { message: "Reservation was successfully destroyed"} , status: :see_other
                                else
                                    render json: {errors: reservation.errors.full_messages}, status: :unprocessable_entity
                                end
                            end
                        else 
                            render json:{ message: "Order item was successfully destroyed"}  , status: :see_other
                        end
                    else
                        render json: {errors: menu.errors.full_messages}, status: :unprocessable_entity
                    end
                else
                    render json: { message: "No menu is found with this id #{order_item.menu_id}"} , status: :no_content
                end
            else
                render json:{ message: "No order item is found with this id #{params[:order_item_id]}"} , status: :not_found
            end
        else
            render json: {message:"No reservation is found with this id #{params[:reservation_id]}"}, status: :not_found
        end
    end

    def new
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation
            order = Order.find_by(id: params[:order_id])
            if order 
                quantity = params[:quantity]
                if quantity and quantity[:food]!="" and params.has_key?("order_item")

                    order_item = params[:order_item]
                    menu = MenuItem.find(order_item[:menu_id])
                    
                    if quantity[:food]== "0" || menu.quantity < quantity[:food].to_i || quantity[:food].to_i<0
                        render json: {message:"quantity available is #{menu.quantity}. Enter correct value.."} , status: :not_acceptable
                    else
                        new_record = order.order_items.create(quantity:quantity[:food],menu_id:order_item[:menu_id],rate:menu.rate,name:menu.name)
        
                        if new_record.save
                            render json: new_record , status: :ok
                        else 
                            reder json: {errors: new_record.errors.full_messages} , status: :unprocessable_entity
                        end
            
                    end
                else 
                    render json: {message:"Check you have filled all details"}, status: :not_acceptable
                end
            else
                render json: {message:"No order is found for reservation with this id #{params[:reservation_id]}"}, status: :not_found
            end
        else
            render json: {message:"No reservation is found with this id #{params[:reservation_id]}"}, status: :not_found
        end
    
        
       
    end

    private
    def is_user_order
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation
            unless current_account and current_account.accountable_type=="User" and current_account.accountable_id==reservation.user_id
                if current_account
                    render json:{message: "You are not authorized !" } , status: :forbidden 
                else
                    render json:{message: "You are not singed in  !" } , status: :unauthorized 
                end
            end
        else
            render json: {message:"No reservation is found with this id #{params[:reservation_id]}"}, status: :not_found
        end
    end
end