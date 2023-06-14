Rails.application.routes.draw do
  root "restaurants#index"
  resources :restaurants do
    resources :tables
    resources :menu_items
  end

  post "restaurant/:id/reservations/index" , to: "reservations#index" , as:"reservation_index"

#table booking
  get "restaurant/:id/reservations/:type" , to: "table_bookeds#table" , as:"reservation_table"
  post "restaurant/:id/reservations/:type/confrim", to: "table_bookeds#confrim" , as:"reservation_table_confrim"
  get "reservations/show" , to: "table_bookeds#show" , as:"reservation_show"
  delete "restaurant/:restaurant_id/reservations/:id", to: "table_bookeds#destroy" , as:"reservation_table_delete"
  get "restaurant/:id/reservations/:reservation_id/edit" , to: "table_bookeds#edit" , as:"reservation_table_edit"
  post "restaurant/:id/reservations/:reservation_id/update" , to: "table_bookeds#update" , as:"reservation_table_update"

#food ordering
  get "restaurant/:id/reservations/:reservation_id/food" , to: "orders#food" , as:"reservation_food"
  post "restaurant/:id/reservations/:reservation_id/food/confrim", to: "orders#confrim" , as:"reservation_food_confrim"
  delete "restaurant/:restaurant_id/reservations/:id/order", to: "orders#destroy" , as:"reservation_order_delete"
  get "restaurant/:id/reservations/:reservation_id/order/edit" , to: "orders#edit" , as:"reservation_order_edit"
  post "restaurant/:id/reservations/:reservation_id/order/update" , to: "orders#update" , as:"reservation_order_update"

 #order items 

  delete "restaurant/:restaurant_id/reservations/:id/order/:order_item_id", to: "order_items#destroy" , as:"reservation_order_items_delete"
  post "restaurant/:restaurant_id/reservations/:id/order/:order_id/new", to: "order_items#new" , as:"reservation_order_items_new"

  #ratings
  get "restaurant/:restaurant_id/reservations/:id/rating" , to:"ratings#new" , as:"reservation_rating_new"
  post "restaurant/:restaurant_id/reservations/:id/rating_create" , to:"ratings#create" , as:"reservation_rating_create"
   
  #table with food
  # get "restaurant/:id/reservations/food" , to: "orders#food" , as:"reservation_food"
  # post "restaurant/:id/reservations/food/confrim", to: "orders#confrim" , as:"reservation_food_confrim"
end