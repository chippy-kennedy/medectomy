
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  include ContentHelper

  protect_from_forgery with: :exception
  
  before_filter :authenticate_user!
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :debugger_help, if: :devise_controller?
  #before_filter :detect_university, if: :devise_controller?
  before_filter :debugger_help, if: :devise_controller?

  # ensures authentication occurs in every action
  check_authorization :unless => :devise_controller?
  helper_method :disqus_sso
  # catches denied access flag raised by CanCan 
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected
DISQUS_SECRET_KEY = 'w9ZlSbxZEzmdzEeTfGrivqsRFhzXpTX5YlcFK47hOW0gFaXdc6j0A6dJC1bjgs3o'
DISQUS_PUBLIC_KEY = '1L7BHGrWA9w5JMfGZYmht5h4c4vWfK1Ye1OVLOUmq3RI0RKcJgD6fP1XmCQp4vAn'
 def disqus_sso(user)
   data = {
      'id' => user['id'],
      'username' => user['username'],
      'email' => user['email']
  #'avatar' => user['avatar'],
  #'url' => user['url']
    }.to_json
 
    # encode the data to base64
    message = Base64.encode64(data).gsub("\n", "")
    # generate a timestamp for signing the message
    timestamp = Time.now.to_i
    # generate our hmac signature
    sig = OpenSSL::HMAC.hexdigest('sha1', DISQUS_SECRET_KEY, '%s %s' % [message, timestamp])
 
    # return a script tag to insert the sso message
    return "
var disqus_config = function() {
this.page.remote_auth_s3 = \"#{message} #{sig} #{timestamp}\";
this.page.api_key = \"#{DISQUS_PUBLIC_KEY}\";
}
"
end

  # checks what parameters can be modified in ActiveRecord
  def permitted_params
  	@permitted_params ||= PermittedParams.new(params, current_user)
  end
  helper_method :permitted_params

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :university_id) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password) }

  end

  def detect_university
    if params[:action] == "create" && params[:controller] = "devise/registrations"
      # try to find a matching domain
      domain = Domain.where(name: params[:user][:email].split("@").last).first

      if domain.nil?
        flash[:notice] = "Your institution does not currently have access to Medectomy. Feel free to contact us for a personal account."
        redirect_to root
      else
        params[:user][:university_id] = domain.university_id
      end
    end
  end

  def debugger_help
    if params[:action] == "create" && params[:controller] = "devise/sessions"
      debugger
      puts "attempted login"
    end
  end



end

