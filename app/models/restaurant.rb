class Restaurant < ApplicationRecord
    has_many :tables , dependent: :destroy
    has_many :menu_items , dependent: :destroy
    has_many :reservations , dependent: :destroy
    belongs_to :owner
    has_many :ratings,as: :rateable
    has_one_attached :images ,dependent: :destroy
    has_many :users , through: :reservations

    #validations

    validates :name, :address , :contact , :city  , :images , presence:true
    validates :contact , length: { minimum: 10 , maximum: 10} , format: { with: /[0-9]/ }
    
    before_create :make_city_lower

    def make_city_lower
      self.city.downcase
    end

    # scope
    scope :rating_greater_than_75, -> { where('restaurants.id IN (?)', Restaurant.pluck(:id).select { |id| Restaurant.find(id).avg_ratings >= 75 }) }
    
    scope :most_reserved, -> {
      joins(:reservations)
        .group('restaurants.id')
        .order('COUNT(reservations.id) DESC')
        .limit(1)
    }

    def avg_ratings
      average_rating = ratings.average(:value)
      if average_rating
      formatted_average_rating =  sprintf('%.2f', average_rating)
      formatted_average_rating.to_f
      else
        0
      end
    end


end
