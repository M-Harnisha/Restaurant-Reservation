class OrderItem < ApplicationRecord
    belongs_to :order
    
    scope :most_frequently_ordered , -> {
        select('order_items.*, menu_id, COUNT(*) as count')
      .group('id, menu_id')
      .order('count DESC')
      .limit(2)
    }

    validates :name, presence:true , length:{ minimum:3 , maximum:15 }
    validates  :rate  , presence:true , numericality: { only_integer: true, greater_than: 0 }
    validates :quantity , presence:true , numericality: { only_integer: true, greater_than: 0 }
    validates :menu_id , presence:true , numericality: { only_integer: true, greater_than: -1 }
end
