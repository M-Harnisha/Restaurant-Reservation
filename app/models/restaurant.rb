class Restaurant < ApplicationRecord
    has_many :tables , dependent: :destroy
    has_many :menu_items , dependent: :destroy
    has_many :reservations , dependent: :destroy
    belongs_to :owner
    has_many :ratings,as: :rateable
    has_one_attached :images ,dependent: :destroy
    validates :name, :address , :contact , :city  , :images , presence:true
    validates :contact , length: { minimum: 10 } , format: { with: /[0-9]/ }
end
