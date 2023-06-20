class Table < ApplicationRecord
    belongs_to :restaurant
    has_and_belongs_to_many :reservations
    validates :name ,:member , presence:true
    validates :name , length: {maximum:10}
end
