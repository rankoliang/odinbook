module ApplicationHelper
  def bootstrap_flash(type)
    bootstrap_type = case type
                     when 'notice', 'success'
                       'success'
                     when 'alert'
                       'danger'
                     else
                       'info'
                     end
    "alert-#{bootstrap_type}"
  end
end
