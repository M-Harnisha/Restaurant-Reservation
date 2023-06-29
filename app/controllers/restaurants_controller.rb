class RestaurantsController < ApplicationController
  before_action :is_owner ,only: [ :new,:create ]
  before_action :is_restaurant , only: [:show,:edit,:update]
  before_action :is_restaurant_owner , only: [:edit,:update,:destroy]
 

  def index
    if account_signed_in? and current_account.accountable_type=="Owner"
      @restaurants = Restaurant.where(owner_id:current_account.accountable_id)
    else 
      @restaurants = Restaurant.all 
    end
  end

  def show
  end

  def new 
    @restaurant = Restaurant.new()
  end

  def create 
    @owner = Owner.find(current_account.accountable_id)
    @restaurant = @owner.restaurants.create(restaurant_params)
    if @restaurant.save
      redirect_to @restaurant , notice:"Created New Restaurant"
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant , notice:"Updated successfully"
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to root_path, status: :see_other
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name,:contact,:address,:city,:images)
  end
  
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
  unless account_signed_in? and current_account.accountable_id==@restaurant.owner_id
    flash[:notice] = "Owner permissions only!!"
    if account_signed_in?
      redirect_to root_path
    else
      redirect_to new_account_session_path
    end
  end
end

def is_restaurant
  if @restaurant = Restaurant.find_by(id: params[:id])
    @restaurant
  else
    redirect_to root_path , notice:"No restaurant is available with given id"
  end
end