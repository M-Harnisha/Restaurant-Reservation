class Rating < ApplicationRecord
    belongs_to :rateable,polymorphic:true
    validates :value , presence:true , numericality:{ only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
