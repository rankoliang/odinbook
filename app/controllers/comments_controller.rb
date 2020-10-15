class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: %i[create]
  before_action :find_comment, only: %i[destroy edit update]
  before_action :find_user, only: %i[destroy edit update]
  before_action :authorize_current_user, only: %i[destroy edit update]

  def create
    @comment = current_user.comment(@post, comment_params)

    if @comment
      redirect_back fallback_location: posts_path, notice: 'Comment posted!'
    else
      redirect_back fallback_location: posts_path, alert: 'Comment failed'
    end
  end

  def destroy
    if @comment.destroy
      redirect_back fallback_location: posts_path, notice: 'Comment deleted!'
    else
      redirect_back fallback_location: posts_path, alert: 'Failed to delete comment.'
    end
  end

  def edit
    session[:edit_redirect] = request.referrer
  end

  def update
    if @comment.update(comment_params)
      edit_redirect = session[:edit_redirect] || posts_path
      session[:edit_redirect] = nil
      redirect_to edit_redirect, notice: 'You have edited your comment'
    else
      render 'edit'
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_comment
    @comment = Comment.includes(:user).find(params[:id])
  end

  def find_user
    @user = @comment.user
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
