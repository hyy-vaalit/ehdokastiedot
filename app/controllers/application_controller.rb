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
    current_admin_user ? admin_dashboard_path : new_advocate_user_session_path
  end

  def current_user
    if current_admin_user
      return current_admin_user
    end

    if current_voting_area_user && current_advocate_user
      raise "#FIXME Cannot handle both AdvocateUser and VotingAreaUser being signed in at the same time. Sign out from either one."
    end

    if current_voting_area_user
      return current_voting_area_user
    else
      return current_advocate_user
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to current_user_login_path, :alert => exception.message
  end

end
