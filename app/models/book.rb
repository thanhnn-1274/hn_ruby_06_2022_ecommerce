class Book < ApplicationRecord
  has_many :order_details, dependent: :nullify
  has_many :comments, dependent: :destroy
  belongs_to :author
  belongs_to :category

  scope :latest_book, ->{order(created_at: :desc)}
end
