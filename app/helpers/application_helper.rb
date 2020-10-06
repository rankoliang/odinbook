module ApplicationHelper
  def bootstrap_flash(flash_type)
    bootstrap_type = case flash_type
                     when 'notice'
                       'success'
                     when 'alert'
                       'danger'
                     else
                       'info'
                     end
    "alert-#{bootstrap_type}"
  end

  def activatable_nav_li(page, custom_classes: [], &block)
    classes = ['nav-items'] + custom_classes
    content = capture(&block)

    classes.push('active') if content_for(:page) == page

    content_tag :li, content, class: classes.join(' ')
  end
end
