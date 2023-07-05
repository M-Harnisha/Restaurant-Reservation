FactoryBot.define do
  factory :reservation do
    date{"2023-10-02"}
    restaurant
    user
  end
end
