class Order < ApplicationRecord
    has_many :order_items ,dependent: :destroy
    belongs_to :reservation
    validates :rate , presence:true , numericality: { only_integer: true, greater_than: -1 }
end
