class Admin::CategoriesController < Admin::AdminController
  before_action :find_category, only: %i(edit update destroy)

  def index
    @pagy, @categories = pagy Category.asc_category_name
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t(".success")
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t(".danger")
      render :new
    end
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

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by id: params[:id]

    return if @category

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end
end
