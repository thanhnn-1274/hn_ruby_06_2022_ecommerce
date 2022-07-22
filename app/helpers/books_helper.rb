module BooksHelper
  def search
    search_text = params[:search_text]
    @books = if search_text.blank?
               Book.all
             else
               Book.search(search_text)
             end
    render :home
  end

  def render_star star
    temp = []
    stared = star.to_i
    stared.times do
      temp << '<i class="fa fa-star" aria-hidden="true"></i>'.html_safe
    end
    (Settings.star - stared).times do
      temp << '<i class="fa fa-star-o" aria-hidden="true"></i>'.html_safe
    end
    safe_join(temp)
  end
end
