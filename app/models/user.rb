class User < ApplicationRecord
    has_many :reservations , dependent: :destroy
    has_many :restaurants, through: :reservations
    has_one :account , as: :accountable 
end
