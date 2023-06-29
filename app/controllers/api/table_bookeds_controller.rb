class Api::TableBookedsController < Api::ApiController

    # before_action :authenticate_account!
    
    before_action :is_user , only: [:table,:confrim,:edit,:update,:destroy,:destroy_each]

    before_action :is_user_table , only: [:edit,:update,:destroy,:destroy_each]


    def table 
        restaurant = Restaurant.find_by(id: params[:id])
        if restaurant
            tables = restaurant.tables
            type = params[:type]
            if tables
                unless type=="table" or type=="food" or type=="table_food"
                    render json: {message:"Invalid type"} , status: :unprocessable_entity
                    return
                end
                render json: tables , status: :ok
                return
            else
                render json: {message:"No table is found for restaurant with this id #{params[:id]}"}, status: :no_content
                return
            end
        else 
            render json: {message:"No restaurant is found with this id #{params[:id]}"}, status: :not_found
            return

        end
    end

    def confrim
        restaurant = Restaurant.find_by(id: params[:id])
        if restaurant
            tables = restaurant.tables 
            type = params[:type]
            date = params.require(:date_id)
            
            unless type=="table" or type=="food" or type=="table_food"

                render json: {message:"Invalid type"} , status: :unprocessable_entity
                return
            else
                if tables

                    if date and date[:date].length!=0
                        reservations = Reservation.where(restaurant_id:restaurant.id)
                        flag=0
                        
                        if date.present? &&  Date.parse(date[:date])< Date.today

                            render json: {message:"Date can't be in past"} , status: :unprocessable_entity
                            return
                        else 
                            if reservations && reservations.each do |reservation|
                                if reservation.date.to_s == date[:date].to_s
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
                                reservation1 = restaurant.reservations.create(user_id:current_account.accountable_id,date:date[:date],restaurant:restaurant)
                                if reservation1.save
                                    tables.each do |table|
                                        tableId = table.id.to_s
                                        if params.has_key?(tableId)
                                            flag=2
                                            reservation1.tables << table
                                        end    
                                    end
                                else
                                    render json: {errors: reservation1.errors.full_messages} , status: :unprocessable_entity 
                                    return
                                end
                            end
                            
                        end
                        if flag==1
                            render json: {message: "Table was already booked"} , status: :unprocessable_entity
                            return
                        elsif flag==0
                            reservation1.destroy
                            render json: {message: "No tables were selected"} , status: :unprocessable_entity
                            return
                        else
                            render json: {reservation: reservation1,reservation_table: reservation1.tables} , status: :ok
                            return
                        end
                    else
                        render json: {message: "Date was not selected"} , status: :unprocessable_entity
                        return
                    end
                else
                    render json: {message: "No tables is found for restaurant with this id #{params[:id]}"}, status: :not_found
                    return
                end
            end
        else
            render json: {message:"No restaurant is found with this id #{params[:id]}"}, status: :not_found
            return
        end     
    end

    def show
        if current_account and current_account.accountable_type=="User"
            user = User.find_by(id: current_account.accountable_id)
            reservations = user.reservations
            if reservations 
                latest_order = user.latest_order
                if latest_order
                    
                    render json: {reservations: reservations , latest_order: latest_order}
                else
                    render json: {message: "No latest order is found for current user"} , status: :no_content
                end
            else 
                render json: {message: "No reservation is found for current user"} , status: :no_content
            end
        elsif current_account and current_account.accountable_type=="Owner"
            owner = Owner.find(current_account.accountable_id)
            restaurants = owner.restaurants.all
            if restaurants 
                render json: restaurants , status: :ok
            else
                render json: {message:"No restaurants available"}
            end 
        end
    end


    def update
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation
            tables = reservation.restaurant.tables 
            date = reservation.date

            if params.has_key?("table_book")

                reservations = Reservation.where(restaurant_id:reservation.restaurant.id)
                update_table = reservation.restaurant.tables.find(params.require(:table_book))
                flag=0

        
                if reservations && reservations.each do |reservation|
                    if reservation.tables.length!=0 && reservation.tables.each do |table|
                        
                        table2 = reservation.restaurant.tables.find(table.id)
                        b = reservation.date
                        if table2 == update_table &&  b.to_s == date.to_s
                            flag=1
                            break
                        end
                    end
                    end
                end
                end

                if flag==1
                    render json: {message:"Table was already booked"} , status: :unprocessable_entity
                else
                    reservation.tables << update_table
                    render json: reservation.tables , status: :ok

                end
                
            else
                render json: {message:"Fill all the details"} , status: :unprocessable_entity
            end  
        else 
            render json: {message: "No reservation is found with id #{params[:reservation_id]}"} , status: :not_found
        end
    end

    def destroy_each
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation
            table = reservation.tables.find_by(id: params[:table_id])
            if table
                reservation.tables.delete(table)
                if reservation.save
                   
                    if reservation.tables.length==0 
                        reservation.destroy
                        render json: {message: "Reservation is destroyed.since there is no tables.."} , status: :see_other
                        return
                    end
                    render json: {reservation: reservation , reservation_table: reservation.tables} , status: :see_other
                else
                    render json: {errors: reservation.errors.full_messages } , status: :unprocessable_entity
                end
                
            else
                render json: {message: "No table is found with id #{params[:table_id]}"} , status: :not_found
            end
        else
            render json: {message: "No reservation is found with id #{params[:reservation_id]}"} , status: :not_found
        end
    end

    def destroy
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation 
            tables = reservation.tables
            if reservation.order
                tables.each do |table|
                    reservation.tables.delete(table)
                end
                reservation.save
                
            else
                reservation.destroy
            end
            render json: {message: "Tables are deleted successfully"} , status: :see_other
        else
            render json: {message: "No reservation is found with id #{params[:reservation_id]}"} , status: :not_found
        end
    end

    private 
   def is_user
        unless current_account and current_account.accountable_type == "User"
            if current_account
                render json:{message: "You are not authorized !" } , status: :forbidden 
            else
                render json:{message: "You are not singed in  !" } , status: :unauthorized 
            end
        end
   end

    def is_user_table
        reservation = Reservation.find_by(id: params[:reservation_id])
        if reservation
            unless account_signed_in? and current_account.accountable_type=="User" and current_account.accountable_id==reservation.user_id
                render json:{message: "You are not authorized !" } , status: :forbidden   
            end
        else
            render json: {message:"No reservation is found with id #{params[:reservation_id]}"} , status: :not_found
        end
    end

end