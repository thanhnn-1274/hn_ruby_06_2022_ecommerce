module BooksHelper
  def render_star star
    temp = []
    stared = star.round
    stared.times do
      temp << '<i class="fa fa-star" aria-hidden="true"></i>'.html_safe
    end
    (Settings.star - stared).times do
      temp << '<i class="fa fa-star-o" aria-hidden="true"></i>'.html_safe
    end
    safe_join(temp)
  end
end
