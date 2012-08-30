class AdvocatesController < ApplicationController

  before_filter :authenticate_advocate_user!
  before_filter :authorize_this!

  def index
  end

  protected

  def authorize_this!
    authorize! :access, :advocate
  end

end
