module ContentHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def devise_error_messages!
    return "" if resource.errors.empty?
    
    messages = resource.errors.full_messages
    
    html = "<div id='notifications' class='panel-body' style='top-margin:50px'>"
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