class ToolsController < ApplicationController

  layout "outside_activeadmin"

  def index
    authorize! :tools, @current_admin_user
  end

end
