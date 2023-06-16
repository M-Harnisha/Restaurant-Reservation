class OrderItemsController < ApplicationController
    before_action :is_user_order , only: [:new,:destroy]

    def destroy
        @reservation = Reservation.find(params[:reservation_id])
        @order = OrderItem.find(params[:order_item_id])
        @order.destroy
        if @reservation.order.order_items.length == 0
            @reservation.order.destroy
        end
            redirect_to reservation_show_path
    end

    def new
        @reservation = Reservation.find(params[:reservation_id])
        @order = @reservation.order
        @flag = 0
        if params.has_key?("quantity") and params.has_key?("order_item")
            @quantity = params[:quantity]
            @order_item = params[:order_item]
            @menu = MenuItem.find(@order_item[:menu_id])

            if @quantity[:food]== "0" || @menu.quantity < @quantity[:food].to_i
                flash[:notice] = "quantity avlailabe is #{@menu.quantity}"
                @flag = 1
            end

            @new_record = @order.order_items.create(quantity:@quantity[:food],menu_id:@order_item[:menu_id],rate:@menu.rate,name:@menu.name)

            if @new_record.save
                redirect_to reservation_show_path
            else 
                redirect_to reservation_order_edit_path(id:params[:id],reservation_id:@reservation)
            end

        else 
            @flag = 1
        end
        if @flag == 1  
            redirect_to reservation_order_edit_path(id:params[:id],reservation_id: @reservation) , notice: "Fill all the details..."
            return
        end
    end

    private
    def is_user_order
        @reservation = Reservation.find(params[:reservation_id])
        unless account_signed_in? and current_account.accountable_type=="User" and current_account.accountable_id==@reservation.user_id
            flash[:notice] = "only booked user can make changes!"
            redirect_to root_path
        end
    end
end