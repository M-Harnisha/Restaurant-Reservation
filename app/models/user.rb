class User < ApplicationRecord
    has_many :reservations , dependent: :destroy
    has_many :restaurants, through: :reservations
    has_one :account , as: :accountable 
    has_one :latest_reservation, -> { order(created_at: :desc).limit(1) }, class_name: 'Reservation'
    has_one :latest_order, through: :latest_reservation, source: :order

    scope :most_reservations_booked, -> {
    joins(:reservations)
      .group('users.id')
      .order('COUNT(reservations.id) DESC')
      .limit(1)
  }
end
