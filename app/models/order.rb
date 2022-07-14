class Order < ApplicationRecord
  enum status: {pending: 0, accepted: 1, complete: 2, canceled: 3}
  ORDER_ATTRS = %w(name address phone_num total_money).freeze
  has_many :order_details, dependent: :destroy
  belongs_to :user

  validates :name, presence: true,
    length: {minimum: Settings.user.name_validates.name_min_length,
             maximum: Settings.user.name_validates.name_max_length}
  validates :address, presence: true,
    length: {minimum: Settings.user.address_min_length,
             maximum: Settings.user.address_max_length}
  validates :phone_num, presence: true,
    length: {minimum: Settings.user.min_phone,
             maximum: Settings.user.max_phone}

  scope :status_order, ->(type){where status: type}
  scope :latest_order, ->{order created_at: :desc}
  scope :status_order, ->(type){where status: type}
end
