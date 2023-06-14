class Reservation < ApplicationRecord
    belongs_to :restaurant
    has_one :table_booked , dependent: :destroy
    has_one :order, dependent: :destroy
    belongs_to :user
    validates :date , presence:true
end
