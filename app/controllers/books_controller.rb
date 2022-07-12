class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    render :show
  end

  def current_book
    @current_book ||= Book.find_by(id: book_id)
  end
end
