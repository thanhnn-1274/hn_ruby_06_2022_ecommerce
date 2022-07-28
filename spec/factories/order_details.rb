require "faker"

FactoryBot.define do
  factory :order_detail do |f|
    f.price {Faker::Commerce.price(range: 1..100.0)}
    f.quantity {Faker::Number.between(from: 1, to: 5)}
  end
end
