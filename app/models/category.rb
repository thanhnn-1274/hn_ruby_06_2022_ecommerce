class Category < ApplicationRecord
  has_many :books, dependent: :nullify
end
