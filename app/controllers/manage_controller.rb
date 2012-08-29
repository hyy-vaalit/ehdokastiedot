class ManageController < ApplicationController
  before_filter :authenticate_admin_user!
  before_filter :authorize_this!


  protected

  def authorize_this!
    raise "Not implemented"
  end
end
