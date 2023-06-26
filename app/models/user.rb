class User < ApplicationRecord
    has_many :reservations , dependent: :destroy
    has_many :restaurants, through: :reservations
    has_one :account , as: :accountable 
    has_one :latest_reservation, -> { order(created_at: :desc).limit(1) }, class_name: 'Reservation'
    has_one :latest_order, through: :latest_reservation, source: :order

    validate :preference_type_must_be_present
    validate :preference_type_have_correct_values
    validates :preference, presence:true

    def preference_type_must_be_present
      if preference.present? and preference['type'].length==0 
        errors.add(:preference, "choose any one prefenrece")
      end
    end
    
    def preference_type_have_correct_values
      if preference.present? and preference['type'].length!=0 
        preference['type'].each do |i|
          if i!='vegetarian' && i!='non-Vegetarian'
            errors.add(:preference, "only given preferences are allowed")
          end
        end
      end
    end
    scope :most_reservations_booked, -> {
    joins(:reservations)
      .group('users.id')
      .order('COUNT(reservations.id) DESC')
      .limit(1)
  }
end
