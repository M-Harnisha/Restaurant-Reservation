class MenuItem < ApplicationRecord
    belongs_to :restaurant
    has_many :ratings,as: :rateable
    has_one_attached :images ,dependent: :destroy
    
    validates :name , :quantity , :rate , presence:true
end
