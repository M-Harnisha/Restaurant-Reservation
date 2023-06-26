class TableBookedsController < ApplicationController
    before_action :authenticate_account!
    
    before_action :is_user , only: [:table,:confrim,:edit,:update,:destroy]

    before_action :is_user_table , only: [:edit,:update,:destroy]


    def table 
        @restaurant = Restaurant.find(params[:id])
        @tables = @restaurant.tables
        @type = params[:type]
    end

    def confrim
        @restaurant = Restaurant.find(params[:id])
        @type = params[:type]
        @date = params.require(:date_id)
        @tables = @restaurant.tables 
        if @date[:date].length!=0
            
            @reservations = Reservation.where(restaurant_id:@restaurant.id)
            flag=0
            
            if @date.present? &&  Date.parse(@date[:date])< Date.today
                redirect_to reservation_table_path(id:params[:id]), notice: "date cant't be in past"
            else 
                if @reservations && @reservations.each do |reservation|
                    if reservation.date.to_s == @date[:date].to_s
                        if reservation.tables && reservation.tables.each do |table1|
                            if params.has_key?(table1.id.to_s)
                                flag=1
                                break
                            end                               
                        end
                        end
                    end
                end
                end

                if flag!=1
                    @reservation1 = @restaurant.reservations.new(user_id:current_account.accountable_id,date:@date[:date],restaurant_id:@restaurant.id)
                    @reservation1.save
                    @tables.each do |table|
                        tableId = table.id.to_s
                        if params.has_key?(tableId)
                            flag=2
                            @reservation1.tables << table
                        end    
                    end
                end
                
            end
            if flag==1
                redirect_to reservation_table_path(id:params[:id]), notice: "Already booked"
            elsif flag==0
                @reservation1.destroy
                redirect_to reservation_table_path(id:params[:id]) , notice:"No tables selected!!"
            else
                if @type=="table"
                    redirect_to reservation_show_path
                else 
                    redirect_to reservation_food_path(id:@restaurant , reservation_id:@reservation.id)
                end
            end
        else
            redirect_to reservation_table_path(id:@restaurant.id,type:@type) , notice: "check whether you have filled all the details.."
        end
    end

    def show
        if account_signed_in? and current_account.accountable_type=="User"
            user = User.find(current_account.accountable_id)
            @reservations = user.reservations
            @latest_order = user.latest_order
        elsif account_signed_in? and current_account.accountable_type=="Owner"
            owner = Owner.find(current_account.accountable_id)
            @restaurants = owner.restaurants.all 
        end
    end

    def edit 
        @restaurant = Restaurant.find(params[:id])
        @reservation = Reservation.find(params[:reservation_id])
        @tables_all = @restaurant.tables
        @tables = @reservation.tables
    end

    def update
        @reservation = Reservation.find(params[:reservation_id])
        @restaurant = Restaurant.find(params[:id])
        @tables = @restaurant.tables 
        date = @reservation.date

        if params.has_key?("table_book")
 
            @reservations = Reservation.where(restaurant_id:@restaurant.id)
            update_table = @restaurant.tables.find(params.require(:table_book))
            flag=0

    
            if @reservations && @reservations.each do |reservation|
                if reservation.tables.length!=0 && reservation.tables.each do |table|
                    
                    @table2 = @restaurant.tables.find(table.id)
                    b = reservation.date
                    if @table2 == update_table &&  b.to_s == date.to_s
                        flag=1
                        break
                    end
                end
                end
            end
        end
            if flag==1
                redirect_to reservation_table_edit_path(id:@restaurant,reservation_id:@reservation), notice: "Already booked"
            else
                @reservation.tables << update_table
            end
            
        else
            redirect_to reservation_table_edit_path(id:@restaurant,reservation_id:@reservation), notice: "check whether you have filled all the details.."
        end  
    end

    def destroy_each
        @reservation = Reservation.find(params[:reservation_id])
        table = Table.find(params[:table_id])
        @reservation.tables.delete(table)
        @reservation.save
        table.save
        if @reservation.tables.length==0 
            @reservation.destroy
        end
        redirect_to root_path, status: :see_other
    end

    def destroy
        @reservation = Reservation.find(params[:reservation_id])
        tables = @reservation.tables
        if @reservation.order
            tables.each do |table|
                @reservation.tables.delete(table)
            end
            @reservation.save
            
        else
            @reservation.destroy
        end
        redirect_to root_path, status: :see_other
    end

    private 
   def is_user
        unless account_signed_in? and current_account.accountable_type=="User"
            flash[:notice] = "User permissions only!!"
            if account_signed_in? 
                redirect_to root_path
            else 
                redirect_to new_account_session_path
            end
        end
   end

    def is_user_table
        @reservation = Reservation.find(params[:reservation_id])
        unless account_signed_in? and current_account.accountable_type=="User" and current_account.accountable_id==@reservation.user_id
            flash[:notice] = "only booked user can make changes!"
            redirect_to root_path
        end
    end

end