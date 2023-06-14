class Owner < ApplicationRecord
    has_many :restaurants , dependent: :destroy
end
