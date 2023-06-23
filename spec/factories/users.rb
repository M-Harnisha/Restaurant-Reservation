FactoryBot.define do
  factory :user do
    preferences:{type=>["vegetarian"]}
    account
  end
end
