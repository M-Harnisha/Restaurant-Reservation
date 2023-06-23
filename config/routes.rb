Rails.application.routes.draw do
  use_doorkeeper
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  

  devise_for :accounts,controllers: {
    sessions: 'accounts/sessions',
    password: 'accounts/passwords',
    registrations: 'accounts/registrations',
    confirmations: 'accounts/confirmations'
  }
  
  root "restaurants#index"

  resources :restaurants do
    resources :tables
    resources :menu_items
  end


post "restaurant/:id/reservations/index" , to: "reservations#index" , as:"reservation_index"

delete "restaurant/:id/reservations/:reservation_id/order", to: "orders#destroy" , as:"reservation_order_delete"

#table booking
  get "restaurant/:id/reservations/:type" , to: "table_bookeds#table" , as:"reservation_table"
  post "restaurant/:id/reservations/:type/confrim", to: "table_bookeds#confrim" , as:"reservation_table_confrim"
  get "reservations/show" , to: "table_bookeds#show" , as:"reservation_show"
  delete "restaurant/:id/reservations/:reservation_id", to: "table_bookeds#destroy" , as:"reservation_table_delete"
  delete "restaurant/:id/reservations/:reservation_id/:table_id", to: "table_bookeds#destroy_each" , as:"reservation_table_each_delete"

  get "restaurant/:id/reservations/:reservation_id/edit" , to: "table_bookeds#edit" , as:"reservation_table_edit"
  post "restaurant/:id/reservations/:reservation_id/update" , to: "table_bookeds#update" , as:"reservation_table_update"

#food ordering
  get "restaurant/:id/reservations/:reservation_id/food" , to: "orders#food" , as:"reservation_food"
  post "restaurant/:id/reservations/:reservation_id/food/confrim", to: "orders#confrim" , as:"reservation_food_confrim"
  get "restaurant/:id/reservations/:reservation_id/order/edit" , to: "orders#edit" , as:"reservation_order_edit"
  patch "restaurant/:id/reservations/:reservation_id/order/update" , to: "orders#update" , as:"reservation_order_update"

 #order items 

  delete "restaurant/:id/reservations/:reservation_id/order/:order_item_id", to: "order_items#destroy" , as:"reservation_order_items_delete"
  post "restaurant/:id/reservations/:reservation_id/order/:order_id/new", to: "order_items#new" , as:"reservation_order_items_new"

  #ratings
  get "restaurant/:id/reservations/:reservation_id/rating" , to:"ratings#new" , as:"reservation_rating_new"
  post "restaurant/:id/reservations/:reservation_id/rating_create" , to:"ratings#create" , as:"reservation_rating_create"
   
  # for api

  namespace :api ,default: {format: :json} do
  devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    

    devise_for :accounts,controllers: {
      sessions: 'accounts/sessions',
      password: 'accounts/passwords',
      registrations: 'accounts/registrations',
      confirmations: 'accounts/confirmations'
    }
    
    root "restaurants#index"

    resources :restaurants do
      resources :tables
      resources :menu_items
    end


  post "restaurant/:id/reservations/index" , to: "reservations#index" , as:"reservation_index"

  delete "restaurant/:id/reservations/:reservation_id/order", to: "orders#destroy" , as:"reservation_order_delete"

  #table booking
    get "restaurant/:id/reservations/:type" , to: "table_bookeds#table" , as:"reservation_table"
    post "restaurant/:id/reservations/:type/confrim", to: "table_bookeds#confrim" , as:"reservation_table_confrim"
    get "reservations/show" , to: "table_bookeds#show" , as:"reservation_show"
    delete "restaurant/:id/reservations/:reservation_id", to: "table_bookeds#destroy" , as:"reservation_table_delete"
    delete "restaurant/:id/reservations/:reservation_id/:table_id", to: "table_bookeds#destroy_each" , as:"reservation_table_each_delete"

    get "restaurant/:id/reservations/:reservation_id/edit" , to: "table_bookeds#edit" , as:"reservation_table_edit"
    post "restaurant/:id/reservations/:reservation_id/update" , to: "table_bookeds#update" , as:"reservation_table_update"

  #food ordering
    get "restaurant/:id/reservations/:reservation_id/food" , to: "orders#food" , as:"reservation_food"
    post "restaurant/:id/reservations/:reservation_id/food/confrim", to: "orders#confrim" , as:"reservation_food_confrim"
    get "restaurant/:id/reservations/:reservation_id/order/edit" , to: "orders#edit" , as:"reservation_order_edit"
    patch "restaurant/:id/reservations/:reservation_id/order/update" , to: "orders#update" , as:"reservation_order_update"

  #order items 

    delete "restaurant/:id/reservations/:reservation_id/order/:order_item_id", to: "order_items#destroy" , as:"reservation_order_items_delete"
    post "restaurant/:id/reservations/:reservation_id/order/:order_id/new", to: "order_items#new" , as:"reservation_order_items_new"

    #ratings
    get "restaurant/:id/reservations/:reservation_id/rating" , to:"ratings#new" , as:"reservation_rating_new"
    post "restaurant/:id/reservations/:reservation_id/rating_create" , to:"ratings#create" , as:"reservation_rating_create"
    

    #custom api

    get "restaurant/:city", to:"restaurants#restaurant_city"
    get "highest_reservation" , to:"restaurants#restaurant_highest_reservations"
    get "restaurant/:id/users" , to: "restaurants#restaurant_users"
    get  "highest_order" , to:"orders#highest_item"
    get "highest_reservation/user" , to:"restaurants#highest_reservation_user"
    
  end

end