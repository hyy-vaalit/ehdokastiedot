class Manage::ConfigurationsController < ManageController
  before_action :find_configuration

  def enable_advocate_login
    GlobalConfiguration.first.enable_advocate_login!
    redirect_to manage_danger_zone_path
  end

  def disable_advocate_login
    GlobalConfiguration.first.disable_advocate_login!
    redirect_to manage_danger_zone_path
  end

  protected

  def authorize_this!
    authorize! :configurations, @current_admin_user
  end

  def find_configuration
    @configuration = GlobalConfiguration.first
  end
end
