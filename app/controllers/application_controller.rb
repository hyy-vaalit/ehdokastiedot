class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization :unless => :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end

  def authorize_admin_access
    authorize! :access, :admin
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, :alert => exception.message
  end

end
