class OrderItemsController < ApplicationController

    def destroy
        @reservation = Reservation.find(params[:id])
        @order = OrderItem.find(params[:order_item_id])
        @order.destroy
        if @reservation.order.order_items.length == 0
            @reservation.order.destroy
        end
            redirect_to reservation_show_url
    end

    def new
        @reservation = Reservation.find(params[:id])
        @order = @reservation.order
        @quantity = params[:quantity]
        @order_item = params[:order_item]
        @menu = MenuItem.find(@order_item[:menu_id])
        @new_record = @order.order_items.create(quantity:@quantity[:food],menu_id:@order_item[:menu_id],rate:@menu.rate,name:@menu.name)
        if @new_record.save
            redirect_to reservation_show_url
        else 
            redirect_to reservation_order_edit_path, status: :see_other
        end
    end

    
end