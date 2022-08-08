class MonthlyOrderWorker
  include Sidekiq::Worker

  def perform
    UserMailer.monthly_order.deliver_later
  end
end
