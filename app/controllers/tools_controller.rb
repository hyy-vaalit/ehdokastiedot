class ToolsController < ApplicationController

  def index
    authorize! :tools, @current_admin_user
  end

end
