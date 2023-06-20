ActiveAdmin.register Reservation do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :restaurant_id, :date, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:restaurant_id, :date, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column :id
    column :restaurant
    column :date
    column :user
    column :order
    column "tables" , :id do |i|
      i.tables do |table|
        link_to table.id , adim_table_path(table.id)
      end
    end
    actions 
  end

  filter :restaurant
  filter :date
  filter :user
  filter :order


end
