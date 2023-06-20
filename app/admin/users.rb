ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :preference
  #
  # or
  #
  # permit_params do
  #   permitted = [:preference]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  scope :most_reservations_booked
  
  index do
    column :id
    column :preference
   
    actions 
  end

end
