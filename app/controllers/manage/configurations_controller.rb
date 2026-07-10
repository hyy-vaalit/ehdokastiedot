class Manage::ConfigurationsController < ManageController
  before_action :find_configuration

  def enable_advocate_login
    GlobalConfiguration.instance.enable_advocate_login!
    redirect_to manage_danger_zone_path
  end

  def disable_advocate_login
    GlobalConfiguration.instance.disable_advocate_login!
    redirect_to manage_danger_zone_path
  end

  protected

  def find_configuration
    @configuration = GlobalConfiguration.instance
  end
end
