class AdvocatesController < ApplicationController

  before_action :authenticate_advocate_user!
  before_action :authorize_this!

  def index
  end

  protected

  def authorize_this!
    authorize! :access, :advocate
  end

end
