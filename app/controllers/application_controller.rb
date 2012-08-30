class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization :unless => :devise_controller?

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def authorize_admin_access
    authorize! :access, :admin
  end

  def current_user_login_path
    current_admin_user ? new_admin_user_session_path : new_advocate_user_session_path
  end

  def current_user
    current_admin_user ? current_admin_user : current_advocate_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to current_user_login_path, :alert => exception.message
  end

end
