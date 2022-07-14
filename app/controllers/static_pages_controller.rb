class StaticPagesController < ApplicationController
  def home
    @pagy, @books = pagy Book.latest_book
    @categories = Category.latest_category
  end
end
