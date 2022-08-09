class Admin::BooksController < Admin::AdminController
  before_action :load_category_author, only: %i(new edit update)
  before_action :find_book, only: %i(edit update destroy)
  before_action :new_book, only: %i(new edit create)

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
    @pagy, @books = pagy @search.result
                                .includes(:category, :author, :image_attachment)
                                .asc_name
  end

  def update
    if params.dig(:book, :status_before_type_cast)
      update_active
    else
      update_all
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

  def new_book
    @category = Category.new
    @author = Author.new
  end

  def find_book
    @book = Book.find_by id: params[:id]

    return if @book

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end

  def update_active
    if @book.update_column(:status, params[:book][:status_before_type_cast])
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".danger")
    end
    redirect_to admin_books_path
  end

  def update_all
    if @book.update book_params
      flash[:success] = t(".success")
      redirect_to admin_books_path
    else
      render :edit
    end
  end
end
