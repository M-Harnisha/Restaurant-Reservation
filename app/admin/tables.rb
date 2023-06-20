ActiveAdmin.register Table do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :member, :restaurant_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :member, :restaurant_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column :id
    column :name
    column :member
    column :restaurant
    actions 
  end

  filter :restaurant
  filter :name
  filter :member

end
