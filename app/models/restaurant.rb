class Restaurant < ApplicationRecord
    paginates_per 3
    has_many :tables , dependent: :destroy
    has_many :menu_items , dependent: :destroy
    has_many :reservations , dependent: :destroy
    belongs_to :owner
    has_many :ratings,as: :rateable
    has_one_attached :images ,dependent: :destroy
    has_many :users , through: :reservations

    #validations

    validates :name, presence:true , length: { minimum: 3 , maximum: 25}
    validates :address , presence:true ,length: { minimum: 5 , maximum: 30} 
    validates :city  , presence: true ,  length: { minimum: 4 , maximum: 15} 
    validates :contact , presence:true, length: { minimum: 10 , maximum: 10} , numericality: { only_integer: true, greater_than: 0 }
    
    before_create :make_lower

    def make_lower
      self.name.downcase!
      self.city.downcase!
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
