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
end
