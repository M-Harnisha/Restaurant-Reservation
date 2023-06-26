FactoryBot.define do
  factory :order_item do
    order
    name{"poori"}
    quantity{10}
    rate{100}
    menu_id{5}
  end
end
