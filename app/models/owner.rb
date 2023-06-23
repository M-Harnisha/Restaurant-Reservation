class Owner < ApplicationRecord
    has_many :restaurants , dependent: :destroy
    has_one :account , as: :accountable
    validates :food_service_id , presence:true
end
