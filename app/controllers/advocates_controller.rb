class AdvocatesController < ApplicationController

  skip_authorization_check

  before_filter :authenticate

  def show
    @advocate = AdvocateUser.find_by_id(session[:advocate])
  end

  private

  def authenticate
    redirect_to new_advocate_session_path unless session[:advocate]
  end

end
