class OrderItemsController < ApplicationController
    before_action :is_user_order , only: [:new,:destroy]

    def destroy
        @reservation = Reservation.find(params[:reservation_id])
        @order = OrderItem.find(params[:order_item_id])
        menu  = MenuItem.find(@order.menu_id)
        available_quantity = menu.quantity + @order.quantity
        menu.update(quantity:available_quantity)
        menu.save
        @order.destroy
        if @reservation.order.order_items.length == 0
            if @reservation.tables.length!=0
                @reservation.order.destroy
            else
                @reservation.destroy
            end
        end
        redirect_to reservation_show_path
    end

    def new
        @reservation = Reservation.find(params[:reservation_id])
        @order = @reservation.order
        @quantity = params[:quantity]
        if @quantity[:food]!="" and params.has_key?("order_item")
            
            @order_item = params[:order_item]
            @menu = MenuItem.find(@order_item[:menu_id])

            if @quantity[:food]== "0" || @menu.quantity < @quantity[:food].to_i
                redirect_to reservation_order_edit_path(id:params[:id],reservation_id: @reservation) , notice: "quantity available is #{@menu.quantity}"
            else
                @new_record = @order.order_items.create(quantity:@quantity[:food],menu_id:@order_item[:menu_id],rate:@menu.rate,name:@menu.name)

                if @new_record.save
                    redirect_to reservation_show_path
                    return
                else 
                    redirect_to reservation_order_edit_path(id:params[:id],reservation_id:@reservation)
                    return
                end
    
            end
        else 
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