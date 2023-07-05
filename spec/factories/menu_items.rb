FactoryBot.define do
  factory :menu_item do
    sequence :name do |n|
      "menu#{n}"
    end
    quantity{10}
    rate{20}
    restaurant
  end
end
