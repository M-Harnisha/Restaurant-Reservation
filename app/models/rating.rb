class Rating < ApplicationRecord
    belongs_to :rateable,polymorphic:true
    validates :value , presence:true
end
