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
    column :preference do |i|
      i.preference.map do |_,value|
        value
      end
    end
   
    actions 
  end
  filter :reservations ,as: :select,collection: proc {Reservation.pluck(:id,:id)}
  filter :restaurants ,as: :select,collection: proc {Restaurant.pluck(:name,:id)}


end
