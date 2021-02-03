class ManageController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :authorize_this!
  before_action :decide_encoding

  protected

  def authorize_this!
    raise "Not implemented"
  end

  def decide_encoding
    if params[:isolatin]
      @encoding = "ISO-8859-1"
    else
      @encoding = "UTF-8"
    end
  end
end
