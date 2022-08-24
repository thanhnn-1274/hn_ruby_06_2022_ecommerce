class Order < ApplicationRecord
  enum status: {pending: 0, accepted: 1, complete: 2, canceled: 3, rejected: 4}
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
  after_save :send_mail_notification
  scope :status_order, ->(type){where status: type}
  scope :latest_order, ->{order created_at: :desc}
  scope :time_order, ->(type){order updated_at: type}
  scope :total_money, ->(type){order total_money: type}
  scope :created_date, ->(date){where "DATE(created_at) = ?", date}
  scope :revenue_day, (lambda do |day|
    where("DATE(created_at) = ? AND status = ?", day, 2).sum :total_money
  end)
  scope :created_month, ->(month){where "MONTH(created_at) = ?", month}
  scope :revenue_m, (lambda do |month|
    where("MONTH(created_at) = ? AND status = ?", month, 2).sum :total_money
  end)
  scope :search, (lambda do |key|
    where "name LIKE ? or id LIKE ?", "%#{key}%", "%#{key}%"
  end)
  scope :order_by_day, (lambda do
    group_by_day(:created_at).count
  end)
  scope :revenue_day_chart, (lambda do |range_d|
    complete.group_by_day(:created_at, range: range_d).sum :total_money
  end)
  scope :revenue_month_chart, (lambda do
    complete.group_by_month(:created_at).sum :total_money
  end)

  ransacker :id do
    Arel.sql("CONVERT(`#{table_name}`.`id`, CHAR(8))")
  end

  def send_mail_pending
    PendingOrderWorker.perform_async id
  end

  def send_mail_accepted
    AcceptedOrderWorker.perform_async id
  end

  def send_mail_canceled
    CanceledOrderWorker.perform_async id
  end

  def send_mail_complete
    CompleteOrderWorker.perform_async id
  end

  def send_mail_rejected
    RejectedOrderWorker.perform_async id
  end

  def handle_order order_params
    ActiveRecord::Base.transaction do
      update!(status: order_params["status"].to_i)
      return true unless complete?

      ActiveRecord::Base.transaction(requires_new: true) do
        order_details.each do |order_detail|
          new_quantity = order_detail.book.quantity - order_detail.quantity
          update_order order_detail, new_quantity
          raise ActiveRecord::Rollback if new_quantity.negative?
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  private

  def send_mail_notification
    status = self.status
    send "send_mail_#{status}"
  end

  def update_order order_detail, new_quantity
    sold = order_detail.book.sold + order_detail.quantity
    order_detail.book.update!(quantity: new_quantity, sold: sold)
  end
end
