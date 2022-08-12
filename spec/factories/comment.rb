# require "faker"

FactoryBot.define do
  factory :comment do
    content {Faker::Lorem.sentence}
    rate {Faker::Number.between(from: 1, to: 5)}
    user {FactoryBot.create :user}
    book {FactoryBot.create :book}
    book_id {book.id}
    user_id {user.id}
  end
end
