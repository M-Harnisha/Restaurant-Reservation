ActiveAdmin.register MenuItem do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :quantity, :rate, :restaurant_id
  #
  # or
  #
  permit_params do
    permitted = [:name, :quantity, :rate, :restaurant_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  scope :greater_than_75
  scope :most_ordered

  index do
    column :id
    column :name
    column :quantity
    column :rate
    column :restaurant
    actions 
  end
  
  filter :restaurant
  filter :rating
  filter :rate
  filter :quantity
end
