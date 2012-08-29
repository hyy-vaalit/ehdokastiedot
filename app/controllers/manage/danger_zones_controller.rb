class Manage::DangerZonesController < ManageController

  def show
  end

  protected

  def authorize_this!
    authorize! :tools, @current_admin_user
  end
end
