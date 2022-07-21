module UsersHelper
  def avatar_image avatar, classname
    content = avatar.attached? ? avatar : Settings.image.default_avatar
    image_tag content, class: classname
  end
end
