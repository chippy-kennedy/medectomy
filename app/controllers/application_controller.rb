class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  #before_filter :detect_university, if: :devise_controller?

  # ensures authentication occurs in every action
  check_authorization :unless => :devise_controller?

  # catches denied access flag raised by CanCan 
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

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
      debugger
    end

  end

end

