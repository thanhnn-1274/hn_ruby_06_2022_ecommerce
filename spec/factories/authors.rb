require "faker"

FactoryBot.define do
  factory :author do |f|
    f.name {Faker::Name.name}
    f.description {Faker::Lorem.sentence}
  end
end
