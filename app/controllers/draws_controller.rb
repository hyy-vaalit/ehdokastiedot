class DrawsController < ApplicationController

  before_filter :authenticate_admin_user!
  before_filter :authorize

  layout "outside_activeadmin"

  def index
    @result = Result.freezed.first
  end


  protected

  def authorize
    authorize! :manage, :draws
  end

end
