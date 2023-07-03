class TableBookedsController < ApplicationController
    before_action :is_signed_in , only: [:show]
    
    before_action :is_user , only: [:table,:confrim,:edit,:update,:destroy,:destroy_each]

    before_action :is_restaurant , except: [:show]

    before_action :is_reservation ,  except: [:table, :confrim, :show, :today_table , :today_table_confrim]

    before_action :is_user_table , except: [:table, :confrim, :show , :today_table , :today_table_confrim]


    def table 
        @tables = @restaurant.tables
        @type = params[:type]
        unless @type=="table" or @type=="food" or @type=="table_food"
            redirect_to root_path , notice:"Invalid type"
        end
    end

    def today_table
         @tables = Table.left_joins(:reservations)
                        .where.not(reservations: {date: Date.today })
                        .or(Table.left_joins(:reservations).where(reservations: { id: nil }))
                        .where(restaurant_id: @restaurant)
    end

    def today_table_confrim
        result = create_reservation(@restaurant,Date.today,params)
        flag = result[0]
        @reservation1 = result[1]
        if flag==0 and @reservation1 
            @reservation1.destroy
            redirect_to today_tables_path(id:params[:id]) , notice:"No tables selected!!"
            return
        else 
            redirect_to reservation_show_path
        end
    end

    def confrim
            @type = params[:type]
            unless @type=="table" or @type=="food" or @type=="table_food"
                redirect_to root_path , notice:"Invalid type"
                return
            end
            @date = params.require(:date_id)
             
            if @date[:date].length!=0
                
                @reservations = Reservation.where(restaurant_id:@restaurant.id)
                flag=0
                
                if @date.present? &&  Date.parse(@date[:date])< Date.today
                    redirect_to reservation_table_path(id:params[:id]), notice: "date cant't be in past"
                    return
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

                    if flag==0
                        result = create_reservation(@restaurant,@date[:date],params)
                        flag = result[0]
                        @reservation1 = result[1]
                    end
                    
                end
                if flag==1
                    redirect_to reservation_table_path(id:params[:id]), notice: "Already booked"
                    return
                elsif flag==0 and @reservation1 
                    @reservation1.destroy
                    redirect_to reservation_table_path(id:params[:id]) , notice:"No tables selected!!"
                    return
                else 
                    if @type=="table"
                        redirect_to reservation_show_path
                        return
                    else 
                        redirect_to reservation_food_path(id:@restaurant , reservation_id:@reservation1.id) , notice:'reserve food now!!'
                        return
                    end
                end
            else
                redirect_to reservation_table_path(id:@restaurant.id,type:@type) , notice: "check whether you have filled all the details.."
                return
            end
    end

    def show
        if account_signed_in? and current_account.accountable_type=="User"
            user = User.find(current_account.accountable_id)
            @reservations = user.reservations.uniq
            @latest_order = user.latest_order
        elsif account_signed_in? and current_account.accountable_type=="Owner"
            owner = Owner.find(current_account.accountable_id)
            restaurants = owner.restaurants.all 
            @reservations = Array.new
            restaurants.each do |restaurant|
                restaurant.reservations.each do |reservation|
                    @reservations.push(reservation)
                end
            end
            p @reservations[0].restaurant
        end
    end

    def edit 
        @tables_all = @restaurant.tables
        @tables = @reservation.tables
    end

    def update
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
                redirect_to reservation_table_edit_path(id:@restaurant,reservation_id:@reservation), notice: "Updated successfully"

            end
            
        else
            redirect_to reservation_table_edit_path(id:@restaurant,reservation_id:@reservation), notice: "check whether you have filled all the details.."
        end  
    end

    def destroy_each
        if table = Table.find_by(id: params[:table_id])
            @reservation.tables.delete(table)
            @reservation.save
            table.save
            if @reservation.tables.length==0 
                @reservation.destroy
            end
            redirect_to reservation_show_path, notice:"Deleted successfully"
        else
            redirect_to root_path, notice:"Not found!.."
        end
    end

    def destroy
        tables = @reservation.tables
        if @reservation.order
            tables.each do |table|
                @reservation.tables.delete(table)
            end
            @reservation.save
            
        else
            @reservation.destroy
        end
        redirect_to root_path, notice:"Deleted successfully"
    end

    private 
    def is_user
        unless account_signed_in? and current_account.accountable_type == "User"
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
            if account_signed_in?
                flash[:notice] = "only booked user can make changes!"
            redirect_to root_path
            else
                redirect_to new_account_session_path
            end
        end
    end

    def is_signed_in
        unless account_signed_in? 
            redirect_to root_path
        end
    end

    def is_restaurant
        if @restaurant = Restaurant.find_by(id: params[:id])
          @restaurant
        else
          redirect_to root_path , notice:"No restaurant is available with given id"
        end
    end

    def is_reservation
        if @reservation = Reservation.find_by(id: params[:reservation_id])
          @reservation
        else
          redirect_to root_path , notice:"No reservation is available with given id"
        end
    end

    def create_reservation( restaurant, date, params)
        flag=0
        tables = restaurant.tables 
        reservation1 = restaurant.reservations.new(user_id:current_account.accountable_id,date:date,restaurant_id:restaurant.id)
        reservation1.save
        tables.each do |table|
            tableId = table.id.to_s
            if params.has_key?(tableId)
                flag=2
                reservation1.tables << table
            end    
        end
        return [flag, reservation1]
    end
end