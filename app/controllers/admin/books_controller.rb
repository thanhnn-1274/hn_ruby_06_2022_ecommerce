class Admin::BooksController < Admin::AdminController
  before_action :load_category_author, only: %i(new)

  def new
    @book = Book.new
  end

  def create
    @book = Book.new book_params
    if @book.save
      flash[:success] = t(".success")
      redirect_to admin_books_path
    else
      load_category_author
      render :new
    end
  end

  def index
    @pagy, @books = pagy Book.asc_name
  end

  private

  def book_params
    params.require(:book).permit(Book::BOOK_ATTRS)
  end

  def load_category_author
    @categories = Category.asc_category_name
    @authors = Author.asc_name
  end
end
