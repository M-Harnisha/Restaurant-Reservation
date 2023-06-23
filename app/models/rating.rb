class Rating < ApplicationRecord
    belongs_to :rateable,polymorphic:true
    validates :value , presence:true , numericality: { only_integer: true, greater_than: -1 }
end
