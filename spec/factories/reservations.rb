FactoryBot.define do
  factory :reservation do
    date{"2023-06-30"}
    restaurant
    user
  end
end
