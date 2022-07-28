require "faker"

FactoryBot.define do
  factory :order do |f|
    f.name {Faker::Name.unique.name}
    f.phone_num {Faker::PhoneNumber.unique.phone_number}
    f.address {Faker::Address.full_address}
  end
end
