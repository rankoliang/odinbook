module Helpers
  def main
    find('main')
  end

  def header
    find('header')
  end

  def pluralize(count, word)
    "#{count} #{word.pluralize}"
  end

  def post_element_for(post)
    id = "post-#{post.id}"
    find_by_id(id)
  end

  def comment_element_for(comment)
    id = "comment-#{comment.id}"
    find_by_id(id)
  end
end
