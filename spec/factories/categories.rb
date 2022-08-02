require "faker"

FactoryBot.define do
  factory :category do |f|
    f.name {|n| "Category #{n}"}
  end
end
