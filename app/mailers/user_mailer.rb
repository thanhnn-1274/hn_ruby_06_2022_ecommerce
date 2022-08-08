class UserMailer < ApplicationMailer
  def pending_order order
    @order = order
    mail to: @order.user.email, subject: t(".subject_pending")
  end

  def canceled_order order
    @order = order
    mail to: @order.user.email, subject: t(".subject_canceled")
  end

  def accepted_order order
    @order = order
    mail to: @order.user.email, subject: t(".subject_accepted")
  end

  def complete_order order
    @order = order
    mail to: @order.user.email, subject: t(".subject_complete")
  end

  def daily_order
    date = Time.zone.today
    @orders = Order.created_date date
    @total_revenue = Order.revenue_day date
    @user = User.find_by email: "admin@gmail.com"
    mail to: @user.email, subject: t(".daily_revenue")
  end

  def monthly_order
    month = Time.zone.today.month
    @orders = Order.created_month month
    @total_revenue = Order.revenue_m month
    @user = User.find_by email: "admin@gmail.com"
    mail to: @user.email, subject: t(".monthly_revenue")
  end
end
