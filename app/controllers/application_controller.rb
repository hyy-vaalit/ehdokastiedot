class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization :unless => :devise_controller?

  # TODO: Remove this after upgrading from Rails 3.0.
  # Required for Ruby 2.0.0 compatibility to overcome
  # "no implicit conversion of nil into String".
  # https://app.asana.com/0/15721084867204/15721084867208
  config.relative_url_root = ""

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def authorize_admin_access
    authorize! :access, :admin
  end

  def current_user_login_path
    current_admin_user ? admin_dashboard_path : new_advocate_user_session_path
  end

  def current_user
    current_admin_user ? current_admin_user : current_advocate_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to current_user_login_path, :alert => exception.message
  end

end
