class Author < ApplicationRecord
  has_many :books, dependent: :nullify
  scope :asc_name, ->{order name: :asc}
end
