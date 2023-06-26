ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :created_at
    actions defaults: false do |admin_user|
    item "View", admin_admin_user_path(admin_user), class: "member_link"
    item "Edit", edit_admin_admin_user_path(admin_user), class: "member_link"
    if AdminUser.count < 1
      item "Delete", admin_admin_user_path(admin_user), class: "member_link", method: :delete, data: { confirm: 'Something will be deleted forever. Sure?' }
    end
  end
  end

  # index do
  #   selectable_column
  #   id_column
  #   column :email
  #   column :current_sign_in_at
  #   column :sign_in_count
  #   column :created_at
  #   actions
  # end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
