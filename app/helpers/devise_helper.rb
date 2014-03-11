module DeviseHelper
  # A simple way to show error messages for the current devise resource. If you need
  # to customize this method, you can either overwrite it in your application helpers or
  # copy the views to your application.
  #
  # This method is intended to stay simple and it is unlikely that we are going to change
  # it to add more behavior or options.
  def devise_error_messages!
    return "" if resource.errors.empty?
    
    messages = resource.errors.full_messages
    
    html = "<div id='notifications' class='panel-body'>"
    messages.each_with_index do |msg, index|
      html = html +
             "<div class='alert alert-danger'>
               <a class='close' data-dismiss='alert'>&#215;</a>
               <div id='flash_#{index}'>#{msg}</div>
             </div>"
    end
    html = html + "</div>"
    
    html.html_safe
  end
end