class Table < ApplicationRecord
    belongs_to :restaurant
    has_and_belongs_to_many :reservations
    validates :name ,:member , presence:true , numericality: { only_integer: true, greater_than: 0 }
    validates :name , length: {maximum:10}
end
