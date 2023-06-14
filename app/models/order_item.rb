class OrderItem < ApplicationRecord
    belongs_to :order
    validates :name , :rate , :quantity , :menu_id , presence:true
end
