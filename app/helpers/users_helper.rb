module UsersHelper
  def avatar_image avatar, classname
    content = avatar.attached? ? avatar : Settings.image.default_avatar
    image_tag content, class: classname
  end

  def total_money_orders user
    user.orders.reduce(0) do |sum, order|
      sum + order.total_money
    end
  end

  def api_current_user
    token = request.headers["auth-token"]
    user_id = JsonWebToken.decode(token)["user_id"] if token
    @api_current_user ||= User.find_by(id: user_id)
  end
end
