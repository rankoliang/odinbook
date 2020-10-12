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
  end

  def update
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
