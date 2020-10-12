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

  def post_within_dom(post)
    id = "post-#{post.id}"
    find_by_id(id)
  end
end
