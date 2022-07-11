class Admin::CategoriesController < Admin::AdminController
  def index
    @pagy, @categories = pagy Category.asc_category_name
  end

  def new
    @category = Category.new
  end

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

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
