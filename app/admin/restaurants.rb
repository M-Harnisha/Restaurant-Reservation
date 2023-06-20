ActiveAdmin.register Restaurant do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :address, :contact, :city, :owner_id
  #
  # or
  #
  permit_params do
    permitted = [:name, :address, :contact, :city, :owner_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  scope :rating_greater_than_75
  scope :most_reserved

  index do
    column :id
    column :name
    column :address
    column :city
    column :contact
    column :owner
    actions 
  end

  filter :tables
  filter :menu_items
  filter :owner
  filter :contact
  filter :city
end
