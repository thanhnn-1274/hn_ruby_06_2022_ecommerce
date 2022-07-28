class Admin::BooksController < Admin::AdminController
  before_action :load_category_author, only: %i(new edit update)
  before_action :find_book, only: %i(edit update destroy)

  authorize_resource

  def new
    @book = Book.new
  end

  def edit; end

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
    @search = Book.ransack(params[:q])
    @pagy, @books = pagy @search.result.asc_name
  end

  def update
    if @book.update book_params
      flash[:success] = t(".success")
      redirect_to admin_books_path
    else
      render :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".danger")
    end
    redirect_to admin_books_path
  end

  private

  def book_params
    params.require(:book).permit(Book::BOOK_ATTRS)
  end

  def load_category_author
    @categories = Category.asc_category_name
    @authors = Author.asc_name
  end

  def find_book
    @book = Book.find_by id: params[:id]

    return if @book

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end
end
