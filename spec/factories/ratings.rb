FactoryBot.define do
  factory :rating do
    value{10}

    trait :for_restaurant do
      association :rateable, factory: :restaurant
    end

    trait :for_menu_item do
      association :rateable ,factory: :menu_item
    end
    
  end
end
