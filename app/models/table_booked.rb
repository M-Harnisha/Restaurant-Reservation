class TableBooked < ApplicationRecord
    belongs_to :reservation
    validates :name , :table_id , presence:true
end
