class RestaurantsController < ApplicationController
  before_action :is_owner ,only: [ :create,:edit,:update,:destroy]
  before_action :is_restaurant_owner , only: [:edit,:update,:destroy]

  def index
    if account_signed_in? and current_account.accountable_type=="Owner"
      @restaurants = Restaurant.where(owner_id:current_account.accountable_id)
    else 
      @restaurants = Restaurant.all 
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new 
    @restaurant = Restaurant.new()
  end

  def create 
    @owner = Owner.find(current_account.accountable_id)
    @restaurant = @owner.restaurants.create(restaurant_params)
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

  private 
  
end
def is_owner
    unless account_signed_in? and current_account.accountable_type=="Owner"
      flash[:notice] = "Owner permissions only!!"
      if account_signed_in?
        redirect_to root_path
      else
        redirect_to new_account_session_path
      end
    end
  end

  def is_restaurant_owner 
    @restaurant = Restaurant.find(params[:id])
    unless account_signed_in? and current_account.accountable_id==@restaurant.owner_id
      flash[:notice] = "Owner permissions only!!"
      redirect_to root_path
    end
  end