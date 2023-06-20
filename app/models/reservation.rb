class Reservation < ApplicationRecord
    belongs_to :restaurant
    has_and_belongs_to_many :tables 
    has_one :order, dependent: :destroy
    belongs_to :user
    validates :date , presence:true
end
