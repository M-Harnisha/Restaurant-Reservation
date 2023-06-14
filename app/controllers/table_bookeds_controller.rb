class TableBookedsController < ApplicationController

    def table 
        @restaurant = Restaurant.find(params[:id])
        @tables = @restaurant.tables
        @type = params[:type]
    end

    def confrim
        @restaurant = Restaurant.find(params[:id])
        @table = @restaurant.tables.find(params.require(:table_book))  
        @date = params.require(:date_id)
        @reservations = Reservation.where(restaurant_id:@restaurant.id)
        @flag=0

        if @date.present? &&  Date.parse(@date[:date])< Date.today
            redirect_to reservation_table_path(id:params[:id]), notice: "date cant't be in past"
        else 
            if @reservation && @reservations.each do |reservation|
                table = reservation.table_booked.table_id
                @table2 = @restaurant.tables.find(table)
                b = reservation.date
                if @table2 == @table &&  b.to_s == @date[:date].to_s
                    @flag=1
                    break
                end
            end
        end
            if @flag==1
                redirect_to reservation_table_path(id:params[:id]), notice: "Already booked"
            else
                @reservation = @restaurant.reservations.new(user_id:1,date:@date[:date],restaurant_id:@restaurant.id)
                if @reservation.save
                    @table_book = @reservation.create_table_booked(table_id:@table.id,name:@table.name)
                    @type = params[:type]
                    if @type=="table"
                        redirect_to reservation_show_url
                    else 
                        redirect_to reservation_food_url(id:@restaurant , reservation_id:@reservation)
                    end
                else 
                    redirect_to reservation_table_path(id:params[:id]) 
                end
            end
        end
    end

    def show
        @user = User.find(1)
        @restaurants = @user.restaurants.all
    end

    def edit 
        @restaurant = Restaurant.find(params[:id])
        @tables = @restaurant.tables
        @reservation = Reservation.find(params[:reservation_id])
    end

    def update
        @reservation = Reservation.find(params[:reservation_id])
        @restaurant = Restaurant.find(params[:id])
        @table = @restaurant.tables.find(params.require(:table_book))  
        @date = params.require(:date_id)
        @reservations = Reservation.where(restaurant_id:@restaurant.id)
        @flag=0

        if @date.present? &&  Date.parse(@date[:date])< Date.today
            redirect_to reservation_table_path(id:params[:id]), notice: "date cant't be in past"
        else 
            @reservations.each do |reservation|
                table = reservation.table_booked.table_id
                @table2 = @restaurant.tables.find(table)
                b = reservation.date
                if @table2 == @table &&  b.to_s == @date[:date].to_s
                    @flag=1
                    break
                end
            end
            if @flag==1
                redirect_to reservation_table_path(id:params[:id]), notice: "Already booked"
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
        
    end

    def destroy
        @reservation = Reservation.find(params[:id])
        @reservation.destroy
        redirect_to root_path, status: :see_other
    end
end