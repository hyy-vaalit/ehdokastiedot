# encoding: utf-8

class Manage::ConfigurationsController < ManageController

  before_filter :authorize_configurations

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

  private

  def authorize_configurations
    authorize! :configurations, @current_admin_user
  end

  protected

  def find_configuration
    @configuration = GlobalConfiguration.first
  end
end