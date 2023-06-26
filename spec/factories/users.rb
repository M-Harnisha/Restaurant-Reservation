FactoryBot.define do
  factory :user do
    preference {{"type"=>["vegetarian", "non-Vegetarian"]}}
  end
end
