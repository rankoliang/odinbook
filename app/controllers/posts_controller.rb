class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: %i[edit update destroy]
  before_action :find_user, only: %i[edit update destroy]
  before_action :authorize_current_user, only: %i[edit update destroy]

  def index
  end

  def create
    post = current_user.posts.build(post_params)

    if post.save
      redirect_back fallback_location: posts_path, notice: 'Post success!'
    else
      render 'index', alert: 'Post failed!'
    end
  end

  def edit
    session[:edit_redirect] = request.referrer
  end

  def update
    if @post.update(post_params)
      edit_redirect = session[:edit_redirect] || posts_path
      session[:edit_redirect] = nil
      redirect_to edit_redirect, notice: 'You have edited your post!'
    else
      render 'edit'
    end
  end

  def destroy
    if @post.destroy
      redirect_back fallback_location: posts_path, alert: 'Post deleted!' 
    else
      redirect_back fallback_location: posts_path, alert: 'Post could not be deleted'
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def find_user
    @user = @post.user
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
