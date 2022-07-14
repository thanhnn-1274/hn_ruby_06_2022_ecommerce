# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/canceled_order
  def canceled_order
    UserMailer.canceled_order
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/complete_order
  def complete_order
    UserMailer.complete_order
  end

end
