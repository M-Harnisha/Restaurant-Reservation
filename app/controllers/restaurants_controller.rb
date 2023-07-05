class RestaurantsController < ApplicationController
  before_action :is_owner ,only: [ :new,:create ]
  before_action :is_restaurant , only: [:show,:edit,:update,:destroy]
  before_action :is_restaurant_owner , only: [:edit,:update,:destroy]
 

  def index
    @restaurants = Restaurant.all
    @index = false

    if account_signed_in? and current_account.accountable_type=="Owner"
      unless params[:name]
        @restaurants = Restaurant.all.page(params[:page])
        @index = true
      else 
        if params[:name] and params[:name].length!=0
          field = params[:field]
          name = params[:name].downcase
          if field=="Name"
            @restaurants = Restaurant.where("name LIKE ?", "%#{name}%")
          elsif field=="City"
            @restaurants = Restaurant.where("city LIKE ?", "%#{name}%")
          elsif field=="MenuItem"
            @restaurants = Restaurant.joins(:menu_items).where("menu_items.name LIKE ?", "%#{name}%")
          end
        end
      end
      @restaurants = @restaurants.where(owner_id:current_account.accountable_id)
    else
      unless params[:name]
        @restaurants = Restaurant.left_outer_joins(:tables, :menu_items)
        .where('tables.id IS NOT NULL OR menu_items.id IS NOT NULL')
        .distinct.page(params[:page])
        @index = true
      else 
        if params[:name] and params[:name].length!=0
          field = params[:field]
          name = params[:name].downcase
          
          if field=="Name"
            @restaurants = Restaurant.left_outer_joins(:tables, :menu_items)
                          .where('tables.id IS NOT NULL OR menu_items.id IS NOT NULL')
                          .where("restaurants.name LIKE ?", "%#{name}%")
                          .distinct
          elsif field=="City"
            @restaurants = Restaurant.left_outer_joins(:tables, :menu_items)
                          .where('tables.id IS NOT NULL OR menu_items.id IS NOT NULL')
                          .where("restaurants.city LIKE ?", "%#{name}%")
                          .distinct
          elsif field=="MenuItem"
            @restaurants = Restaurant.left_outer_joins(:tables, :menu_items)
                          .where('tables.id IS NOT NULL OR menu_items.id IS NOT NULL')
                          .where("menu_items.name LIKE ?", "%#{name}%")
                          .distinct
          end 
        end
      end    
    end 
  end

  def show 
  end
  # modeling and demodeling , trasormation model ,image procesing

  def new 
    @restaurant = Restaurant.new()
  end

  def create 
    @owner = Owner.find(current_account.accountable_id)
    @restaurant = @owner.restaurants.create(restaurant_params)
    if @restaurant.save
      redirect_to @restaurant , notice:"Created New Restaurant"
    else
      flash.now[:alert] = 'Failed to save restaurant'
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
  @restaurant = Restaurant.find_by(id: params[:id])
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