class Reservation < ApplicationRecord
    belongs_to :restaurant
    has_and_belongs_to_many :tables , dependent: :destroy
    has_one :order, dependent: :destroy
    belongs_to :user
    validates :date , presence:true
    validate :date_must_not_be_in_the_past  
    # validate :date_format_is_not_correct 


    def date_must_not_be_in_the_past
        if date.present? && date.is_a?(Date) && date < Date.today
          errors.add(:date, "can't be in the past")
        end
    end

    def date_format_is_not_correct
      if date.present? && Date.parse(date)
        true
      end
    rescue 
      errors.add(:date, "Date format is not correct")
    end
end
