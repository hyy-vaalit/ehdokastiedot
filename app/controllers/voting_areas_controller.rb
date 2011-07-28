class VotingAreasController < ApplicationController

  skip_authorization_check

  before_filter :authenticate
  skip_before_filter :authenticate, :only => [:login, :login_post]

  def show
  end

  def login
  end

  def login_post
    @voting_area = VotingArea.authenticate params[:username], params[:password]
    session[:voting_area_id] = @voting_area.id if @voting_area
    redirect_to voting_area_path
  end

  def logout
    session[:voting_area_id] = nil
    redirect_to voting_area_path
  end

  private

  def authenticate
    redirect_to login_voting_area_path unless session[:voting_area_id]
  end

end
