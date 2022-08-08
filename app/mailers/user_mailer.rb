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
end
