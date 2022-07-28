class StaticPagesController < ApplicationController
  def home
    if params[:search].blank?
      @pagy, @books = pagy Book.view_desc
    else
      @pagy, @books = pagy Book.search_by_name_description(params[:search])
    end
    @categories = Category.latest_category
  end
end
