# spec/factories/user.rb
require "faker"

FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    address {Faker::Address.full_address}
    phone_num {Faker::PhoneNumber.unique.phone_number}
    password {"123456"}
    password_confirmation {"123456"}
    role {1}
  end
end
