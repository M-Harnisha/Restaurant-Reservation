class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new 
    @owner = Owner.find(1)
    @restaurant = Restaurant.new()
  end

  def create 
    @restaurant_datas = restaurant_params
    @restaurant_datas[:owner_id]= 1
    @restaurant = Restaurant.new(@restaurant_datas)
    if @restaurant.save
      redirect_to @restaurant
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to root_path, status: :see_other
  
  end
  private
  def restaurant_params
    params.require(:restaurant).permit(:name,:contact,:address,:city,:images)
  end

end
