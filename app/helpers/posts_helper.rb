module PostsHelper
  def likes(post)
    pluralize(post.num_likes, 'Like')
  end
end
