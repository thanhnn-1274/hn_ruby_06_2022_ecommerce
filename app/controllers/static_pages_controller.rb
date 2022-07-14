class StaticPagesController < ApplicationController
  def home
    @pagy, @books = pagy Book.search(params[:search])
    @categories = Category.latest_category
  end
end
