class AdvocatesController < ApplicationController

  skip_authorization_check

  before_filter :authenticate

  layout "outside_activeadmin"

  def show
  end

  private

  def authenticate
    @advocate = AdvocateUser.find_by_id(session[:advocate])
    redirect_to new_advocate_session_path unless @advocate
  end

end
