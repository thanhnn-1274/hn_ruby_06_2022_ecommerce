class Admin::AuthorsController < Admin::AdminController
  load_and_authorize_resource

  def new; end

  def create
    @author = Author.new author_params
    if @author.save
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".danger")
    end
    redirect_to new_admin_book_path
  end

  private

  def author_params
    params.require(:author).permit(:name)
  end
end
