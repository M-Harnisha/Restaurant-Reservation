class MenuItem < ApplicationRecord
    belongs_to :restaurant
    has_many :ratings,as: :rateable
    has_one_attached :images ,dependent: :destroy
    
    scope :greater_than_75 , -> {
      where('menu_items.id IN (?)', MenuItem.pluck(:id).select { |id| MenuItem.find(id).avg_ratings >= 75 }) 
    }

    scope :most_ordered, -> {
      where(id: OrderItem.select('menu_id::bigint').group('menu_id').order('COUNT(order_items.id) DESC').limit(5))
    }
    
    def avg_ratings
      average_rating =ratings.average(:value)
      if average_rating
      formatted_average_rating =  sprintf('%.2f', average_rating)
      formatted_average_rating.to_f
      else
        0
      end
    end

    validates :name , presence:true
    validates :quantity , :rate , presence:true ,numericality: { only_integer: true, greater_than: 0 }
end
