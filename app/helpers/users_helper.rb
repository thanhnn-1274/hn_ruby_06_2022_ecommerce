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
end
