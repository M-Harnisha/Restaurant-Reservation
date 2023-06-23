class Api::RestaurantsController < Api::ApiController
  before_action :is_owner ,only: [ :create,:edit,:update,:destroy]
  before_action :is_restaurant_owner , only: [:edit,:update,:destroy]

  def index
    if current_account and current_account.accountable_type=="Owner"
      restaurants = Restaurant.where(owner_id:current_account.accountable_id)
      if restaurants.length != 0 
          render json: restaurants, status: :ok
      else
        render json: {message:"No restaurants available" }, status: :no_content
      end
    else 
      restaurants = Restaurant.all 
      if restaurants.length != 0 
        render json: restaurants, status: :ok
      else
        render json: {message:"No restaurants available" }, status: :no_content
      end
    end
   

  end

  def show
    restaurant = Restaurant.find_by(id: params[:id])
    if restaurant
      render json: restaurant, status: :ok
    else
      render json: {message:"No restaurant is found with id #{params[:id]}"}, status: :not_found
    end
  end

  def new 
    restaurant = Restaurant.new()
    if restaurant
      render json: restaurant, status: :ok
    else
      render json: {message:"Can't create restaurant"}, status: :unprocessable_entity
    end
  end

  def create 
    owner = Owner.find_by(id: current_account.accountable_id)
    if owner 
      restaurant = owner.restaurants.create(restaurant_params)
      if restaurant.save
        render json: restaurant , status: :created
      else 
        render json: {errors: restaurant.errors.full_messages} , status: :unprocessable_entity
      end
    else
      render json: {message:"No owner is found with this id #{current_account.accountable_id}"} , status: :not_found
    end
  end

  def edit
    restaurant = Restaurant.find_by(id: params[:id])
    if restaurant
      render json: restaurant , status: :ok
    else 
      render json: {message:"No restaurant is found with id #{params[:id]}"} , status: :not_found
    end
  end

  def update
    restaurant = Restaurant.find_by(id: params[:id])
    if restaurant
      restaurant.update(restaurant_params)
      if restaurant.save
        render json: restaurant , status: :ok
      else 
        render json: {errors: restaurant.errors.full_messages} , status: :unprocessable_entity
      end
    else
      render json: {message:"No restaurant is found with id #{params[:id]}"} , status: :not_found
    end
  end

  def destroy
    restaurant = Restaurant.find_by(id: params[:id])
    if restaurant
      if restaurant.destroy
        render json: restaurant , status: :see_other
      else 
        render json: {errors: restaurant.errors.full_messages } , status: :unprocessable_entity
      end
    else
      render json: {message:"No restaurant is found with id #{params[:id]}"} , status: :not_found
    end
  
  end

  def restaurant_city
    city = params[:city].downcase
    restaurants  = Restaurant.find_by(city: city)
    if restaurants 
      render json: restaurants , status: :ok
    else
      render json: {message: "No restaurant is available with city as #{city}"} , status: :not_found
    end
  end

  def restaurant_highest_reservations
    restaurants = Restaurant.joins(:reservations)
    .group('restaurants.id')
    .order('COUNT(reservations.id) DESC')
    .first

    if restaurants
      render json:restaurants , status: :ok
    else 
      render json: {message: "No restaurants found"} , status: :not_found
    end

  end
  
  def restaurant_users
    restaurant = Restaurant.find_by(id: params[:id])
    restaurant_users = restaurant.users
    if restaurant_users
      render json: restaurant_users , status: :ok
    else
      render json: {message:"No users available"} , status: :not_found
    end
  end

  def highest_reservation_user
    users = User.joins(:reservations)
    .group('users.id')
    .order('COUNT(reservations.id) DESC')
    .first

    if users
      render json: users , status: :ok
    else
      render json: {message:"No users "} , status: :not_found
    end
  end

  private
    def restaurant_params
      params.require(:restaurant).permit(:name,:contact,:address,:city,:images)
    end

  private 
  def is_owner
      unless current_account and current_account.accountable_type=="Owner"
        render json:{message: "You are not authorized !" } , status: :unauthorized
      end
  end

  def is_restaurant_owner 
    restaurant = Restaurant.find_by(id: params[:id])
    if restaurant
      unless current_account and current_account.accountable_id==restaurant.owner_id
        render json:{message: "You are not authorized !" } , status: :unauthorized
      end
    else
      render json: {message:"No restaurant is found with id #{params[:id]}"} , status: :not_found
    end
  end

end