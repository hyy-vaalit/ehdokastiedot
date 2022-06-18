# ActiveAdmin's controllers do not fully inherit from ApplicationController,
# but loading of ActiveAdmin resources causes ApplicationController being
# invoked as if the ActiveAdmin would have inherited from it. Normally
# you can use ApplicationController as you would, but there are some
# side-effects such as failing to respect `check_authorization` (see below).
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
    current_admin_user ? admin_dashboard_path : new_advocate_user_session_path
  end

  def current_user
    return current_admin_user if current_admin_user
    return current_advocate_user if current_advocate_user

    return nil # guest
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "[ApplicationController] Access denied on action: '#{exception.action}' subject: '#{exception.subject.inspect}'"
    redirect_to unauthorized_path, :alert => exception.message
  end
end
