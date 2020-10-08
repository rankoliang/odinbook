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
end
