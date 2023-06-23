class Reservation < ApplicationRecord
    belongs_to :restaurant
    has_and_belongs_to_many :tables 
    has_one :order, dependent: :destroy
    belongs_to :user
    validates :date , presence:true
    validate :date_must_not_be_in_the_past

    def date_must_not_be_in_the_past
        if date.present? && date < Date.today
          errors.add(:date, "can't be in the past")
        end
    end
end
