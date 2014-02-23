class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # ensures authentication occurs in every action
  check_authorization :unless => :devise_controller?

  # catches denied access flag raised by CanCan 
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  # checks what parameters can be modified in ActiveRecord
  def permitted_params
  	@permitted_params ||= PermittedParams.new(params, current_user)
  end
  helper_method :permitted_params

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
  end

end

