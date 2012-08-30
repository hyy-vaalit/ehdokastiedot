# encoding: utf-8

class Manage::ConfigurationsController < ManageController

  before_filter :find_configuration

  def update
    if @configuration.update_attributes(params[:global_configuration])
      flash[:notice] = "Muutokset tallennettu."
      redirect_to :action => :edit
    else
      flash[:alert] = "Muutosten tallentaminen epäonnistui!"
      render :action => :edit and return
    end

  end

  def edit
  end

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
