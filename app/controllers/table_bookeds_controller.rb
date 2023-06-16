class TableBookedsController < ApplicationController
    before_action :authenticate_account!
    
    before_action :is_user , only: [:table,:show,:confrim,:edit,:update,:destroy]

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

        if params.has_key?("table_book") && @date[:date].length!=0
            
            @table = @restaurant.tables.find(params.require(:table_book))
            @reservations = Reservation.where(restaurant_id:@restaurant.id)
            @flag=0
            
            if @date.present? &&  Date.parse(@date[:date])< Date.today
                redirect_to reservation_table_path(id:params[:id]), notice: "date cant't be in past"
            else 
                if @reservations && @reservations.each do |reservation|
                    if reservation.table_booked
                        table = reservation.table_booked.table_id
                        @table2 = @restaurant.tables.find(table)
                        puts "`````````````````````"
                        puts @table2.id
                        puts @table.id
                        b = reservation.date
                        if @table2 == @table &&  b.to_s == @date[:date].to_s
                            @flag=1
                            break
                        end
                    end
                end
            end
            if @flag==1
                redirect_to reservation_table_path(id:params[:id]), notice: "Already booked"
            else
                @reservation = @restaurant.reservations.new(user_id:current_account.accountable_id,date:@date[:date],restaurant_id:@restaurant.id)
                if @reservation.save
                    @table_book = @reservation.create_table_booked(table_id:@table.id,name:@table.name)
                    
                    if @type=="table"
                        redirect_to reservation_show_path
                    else 
                        redirect_to reservation_food_path(id:@restaurant , reservation_id:@reservation.id)
                    end
                else 
                    redirect_to reservation_table_path(id:params[:id]) 
                end
            end
        end
        else
            redirect_to reservation_table_path(id:@restaurant.id,type:@type) , notice: "check whether you have filled all the details.."
        end
    end

    def show
        if account_signed_in? and current_account.accountable_type=="User"
            @user = User.find(current_account.accountable_id)
            @restaurants = @user.restaurants.all.uniq
        end
    end

    def edit 
        @restaurant = Restaurant.find(params[:id])
        @tables = @restaurant.tables
        @reservation = Reservation.find(params[:reservation_id])
    end

    def update
        @reservation = Reservation.find(params[:reservation_id])
        @restaurant = Restaurant.find(params[:id])
        @date = params.require(:date_id)

        if params.has_key?("table_book") && @date[:date].length!=0

            @table = @restaurant.tables.find(params.require(:table_book))  
            @reservations = Reservation.where(restaurant_id:@restaurant.id)
            @flag=0

            if @date.present? &&  Date.parse(@date[:date])< Date.today
                redirect_to reservation_table_path(id:params[:id]), notice: "date cant't be in past"
            else 
                if @reservations && @reservations.each do |reservation|
                    if reservation.table_booked
                        table = reservation.table_booked.table_id
                        @table2 = @restaurant.tables.find(table)
                        b = reservation.date
                        if @table2 == @table &&  b.to_s == @date[:date].to_s
                            @flag=1
                            break
                        end
                    end
                end
            end
                if @flag==1
                    redirect_to reservation_table_edit_path(id:@restaurant,reservation_id:@reservation), notice: "Already booked"
                else
                    if @reservation.update(date:@date[:date],restaurant_id:@restaurant.id)
                        if @reservation.table_booked.update(table_id:@table.id,name:@table.name)
                            redirect_to reservation_show_url
                        else 
                            render :edit, status: :unprocessable_entity 
                        end
                    else 
                        render :edit, status: :unprocessable_entity
                    end
                end
            end
        else
            redirect_to reservation_table_edit_path(id:@restaurant,reservation_id:@reservation), notice: "check whether you have filled all the details.."
        end  
    end

    def destroy
        @reservation = Reservation.find(params[:reservation_id])
        if @reservation.order && @reservation.table_booked
            @table = @reservation.table_booked
            @table.destroy
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