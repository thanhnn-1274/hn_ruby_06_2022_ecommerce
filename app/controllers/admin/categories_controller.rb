class Admin::CategoriesController < Admin::AdminController
  before_action :find_category, except: %i(new index trash create)

  authorize_resource

  def index
    @pagy, @categories = pagy Category.without_deleted.asc_category_name
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t(".success")
      render json: @category, status: :created
    else
      flash[:danger] = t(".danger")
    end
    redirect request.referer
  end

  def update
    if @category.update category_params
      flash[:success] = t(".success")
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t(".danger")
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".danger")
    end
    redirect_to admin_categories_path
  end

  def restore
    respond_to do |format|
      if @category.restore(recursive: true)
        format.js{flash.now[:success] = t(".restored_success")}
      else
        @categories = Category.only_deleted
        flash.now[:danger] = t(".restore_fail")
        render :trash
      end
    end
  end

  def really_destroy
    if !@category.books.exists? && @category.really_destroy!
      flash.now[:success] = t ".really_destroy_success"
    else
      @categories = Category.only_deleted
      flash.now[:danger] = t ".really_destroy_fail"
    end
    render :trash
  end

  def trash
    @categories = Category.only_deleted
    respond_to :js
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.with_deleted.find_by id: params[:id]

    return if @category

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end

  def redirect request
    if request.include? :books.to_s
      redirect_to new_admin_book_path
    else
      redirect_to admin_categories_path
    end
  end
end
