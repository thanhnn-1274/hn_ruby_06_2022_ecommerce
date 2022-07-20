class Order < ApplicationRecord
  enum status: {pending: 0, accepted: 1, rejected: 2, complete: 3, canceled: 4}

  has_many :order_details, dependent: :destroy
  belongs_to :user

  scope :latest_order, ->{order created_at: :desc}
end
