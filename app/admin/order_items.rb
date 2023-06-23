ActiveAdmin.register OrderItem do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :quantity, :rate, :order_id, :menu_id, :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:quantity, :rate, :order_id, :menu_id, :name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # scope :most_frequently_ordered
  
  index do

    column :id
    column :name
    column :quantity
    column :rate
    column :order
    column "Menu ID" , :id do |i|
      link_to i.menu_id , admin_menu_item_path(i.menu_id)
    end
    actions 
  end

  filter :order_id
  filter :quantity
  filter :rate
  filter :menu_id
  filter :name
  
end
