ActiveAdmin.register Rating do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :value, :rateable_type, :rateable_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:value, :rateable_type, :rateable_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column :id
    column :value
    column :rateable_type
    column "Rateable Name" , :rateable
   
    actions 
  end

  filter :value
  filter :rateable_type
  filter :rateable_id.name  
end
