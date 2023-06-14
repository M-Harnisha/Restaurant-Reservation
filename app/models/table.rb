class Table < ApplicationRecord
    belongs_to :restaurant
    validates :name ,:member , presence:true
    validates :name , length: {maximum:10}
end
