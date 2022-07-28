class StaticPagesController < ApplicationController
  def home
    @pagy, @books = pagy @search.result.view_desc
    @categories = Category.latest_category
  end
end
