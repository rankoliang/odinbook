class StaticPagesController < ApplicationController
  def index
    @feed = Post.feed(current_user) if user_signed_in?
  end
end
