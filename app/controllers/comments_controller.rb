class CommentsController < ApplicationController
  before_action :logged_in_user, only: :create

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.image.attach(params[:comment][:image])
    @status = @comment.save
    respond_to do |format|
      format.html{redirect_to root_path}
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit Comment::COMMENT_ATTRS
  end
end
