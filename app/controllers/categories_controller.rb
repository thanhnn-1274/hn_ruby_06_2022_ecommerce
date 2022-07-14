class CategoriesController < ApplicationController
  before_action :find_category, only: %i(show)
  before_action :load_book, only: %i(show)

  def show
    respond_to :js
  end

  private

  def find_category
    @category = Category.find_by id: params[:id]

    return if @category

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end

  def load_book
    @pagy, @books = pagy @category.books, link_extra: 'data-remote="true"'
  end
end
