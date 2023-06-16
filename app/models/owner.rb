class Owner < ApplicationRecord
    has_many :restaurants , dependent: :destroy
    has_one :account , as: :accountable
end
