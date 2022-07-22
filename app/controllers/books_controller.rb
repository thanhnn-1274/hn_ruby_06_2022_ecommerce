class BooksController < ApplicationController
  def index; end

  def show
    @book = Book.find_by id: params[:id]
    @comment = current_user.comments.build if logged_in?
    @comments = Comment.by_book_id(params[:id]).latest_comment.includes(:user)
    return if @book

    flash[:warning] = t ".not_found"
    redirect_to root_path
  end

  def sort
    if params[:sort]
      @pagy, @books = sort_by params[:sort]
      respond_to :js
    else
      redirect_to root_url
    end
  end

  private

  def sort_by params
    case params.to_sym
    when :latest
      pagy Book.latest_book, link_extra: 'data-remote="true"'
    when :asc, :desc
      pagy Book.sort_price(params.to_sym), link_extra: 'data-remote="true"'
    end
  end
end
