class StaticPagesController < ApplicationController
  def index
    @feed = Post.feed(current_user, page: params[:page])
  end
end
