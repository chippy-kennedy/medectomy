class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # ensures authentication occurs in every action
  check_authorization

  # catches denied access flag raised by CanCan 
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  # checks what parameters can be modified in ActiveRecord
  def permitted_params
  	@permitted_params ||= PermittedParams.new(params, current_user)
  end
  helper_method :permitted_params

end

