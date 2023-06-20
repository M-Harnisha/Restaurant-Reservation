class OrderItem < ApplicationRecord
    belongs_to :order
    
    scope :most_frequently_ordered , -> {
        select('order_items.*, menu_id, COUNT(*) as count')
      .group('id, menu_id')
      .order('count DESC')
      .limit(2)
    }

    validates :name , :rate , :quantity , :menu_id , presence:true
end
