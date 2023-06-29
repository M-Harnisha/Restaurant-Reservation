FactoryBot.define do
  factory :account do
    
    sequence :email do |n|
      "test#{n}@gmail.com"
    end
    name{"Harnisha"}
    contact{"9842040552"}
    password{"123456"}
    password_confirmation{"123456"}
  
    trait :for_user do
      association :accountable, factory: :user
    end

    trait :for_owner do
      association :accountable ,factory: :owner
    end
    
  end
end
