FactoryBot.define do
  factory :restaurant do
    sequence :name do |n|
      "restaurant#{n}"
    end
   
    address{"lkjhg nagar"}
    contact{"9874561239"}
    city{"erode"}
    owner
  end
end
