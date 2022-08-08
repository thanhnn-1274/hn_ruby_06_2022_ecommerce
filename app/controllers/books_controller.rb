class BooksController < ApplicationController
  authorize_resource

  def index
    @pagy, @books = pagy @search.result.includes(:category).view_desc
    @categories = Category.latest_category
  end

  def show
    @book = Book.find_by id: params[:id]
    @comment = current_user.comments.build if user_signed_in?
    @comments = Comment.by_book_id(params[:id]).latest_comment.includes(:user)
    if @book
      @book.update_view
    else
      flash[:warning] = t ".not_found"
      redirect_to root_path
    end
  end
end
