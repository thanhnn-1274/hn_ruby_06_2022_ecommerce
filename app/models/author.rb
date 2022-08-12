class Author < ApplicationRecord
  has_many :books, dependent: :nullify

  validates :name, presence: true

  scope :asc_name, ->{order name: :asc}
end
