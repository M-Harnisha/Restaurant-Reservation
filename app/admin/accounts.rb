ActiveAdmin.register Account do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :accountable_id, :accountable_type, :name, :contact
  #
  # or
  #
  permit_params do
    permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :accountable_id, :accountable_type, :name, :contact]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
  index do
    column :name
    column :contact
    column :email
    column :accountable
    column :accountable_type
    actions 
  end
  
end
