ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :rate, :reservation_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:rate, :reservation_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column :id
    column "Total rate" , :rate
    column "Reservation Id" , :id do |i|
      link_to i.reservation_id , admin_reservation_path(i.reservation_id)
    end
    actions 
  end

  filter :rate
  filter :order_items, as: :select,collection: proc {OrderItem.pluck(:name,:id)}
end
