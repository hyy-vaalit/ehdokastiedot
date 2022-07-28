# ActiveAdmin's controllers do not fully inherit from ApplicationController,
# but loading of ActiveAdmin resources causes ApplicationController being
# invoked as if the ActiveAdmin would have inherited from it. Normally
# you can use ApplicationController as you would, but there are some
# side-effects such as failing to respect `check_authorization` (see below).
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_current_haka_user

  # CanCan::ControllerAdditions::ClassMethods
  # https://www.rubydoc.info/github/CanCanCommunity/cancancan/CanCan/ControllerAdditions/ClassMethods
  check_authorization :unless => :devise_or_active_admin?

  protected

  # Ignore authorization for
  # - Devise: allow guest access to login
  # - ActiveAdmin: AA will call `authorize_admin_access` defined in initializer.
  #   ActiveAdmin::CanCanAdapter is not compatible with CanCan controllers,
  #   which will always fail `authorize_resource` check. CanCan expects an
  #   instance variable @_authorized be set, but it's undefined by AA's adapter.
  #
  # Issue: https://github.com/activeadmin/activeadmin/issues/4599
  def devise_or_active_admin?
    devise_controller? || active_admin_resource?
  end

  def active_admin_resource?
    self.class.ancestors.include? ActiveAdmin::BaseController
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_user)
  end

  # ActiveAdmin calls this method as a before_action
  # (defined in config/initializers/active_admin.rb).
  def authorize_admin_access
    # There's a problem with Active Admin 1.0.0pre4 which makes ActiveAdmin
    # to authorize_admin_access also on login page. Normally that would be
    # omitted with `unless: :devise_controller?` but it's not respected
    # by Active Admin 1.0.0pre4 and devise_controller? returns false
    # for `ActiveAdmin::Devise::SessionsController`. Hence the manual override.
    if self.instance_of?(ActiveAdmin::Devise::SessionsController)
      authorize! :login, :admin
    else
      authorize! :access, :admin
    end
  end

  def current_user_login_path
    current_admin_user ? admin_dashboard_path : haka_auth_new_path
  end

  def current_user
    return current_admin_user if current_admin_user
    return current_haka_user if current_haka_user

    return nil # guest
  end

  # Exposed to View in ApplicationHelper#current_advocate_user
  def current_advocate_user
    @current_haka_user&.advocate_user
  end

  # Exposed to View in ApplicationHelper#current_haka_user
  def current_haka_user
    @current_haka_user
  end

  def set_current_haka_user
    track_session_expiry

    @current_haka_user ||= HakaUser.new(attrs: session[:haka_attrs]) if session[:haka_attrs]
  end

  def track_session_expiry
    if session_timeout_at && Time.now.getutc > session_timeout_at
      reset_session
      flash.alert = "Istunto on vanhenunt ja selaimesi kirjattiin ulos."

      redirect_to root_path
    end

    session[:timeout_at] = 60.minutes.from_now.getutc.to_i
  end

  def session_timeout_at
    return nil unless session[:timeout_at]

    Time.at(session[:timeout_at])
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "[ApplicationController] Access denied on action: '#{exception.action}' subject: '#{exception.subject.inspect}'"
    flash.now.alert = exception.message
    render "common/unauthorized"
  end
end
