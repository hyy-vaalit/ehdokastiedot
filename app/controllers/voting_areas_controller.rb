# coding: UTF-8
class VotingAreasController < ApplicationController

  skip_authorization_check

  before_filter :authenticate, :except => [:login, :login_post]

  before_filter :assign_voting_area, :except => [:login, :login_post]

  layout "outside_activeadmin"

  def show
  end

  def create
    begin
      @voting_area.give_votes! params[:votes]
    rescue => e
      flash[:errors] = e.message
    end
    redirect_to voting_area_path(:anchor => 'vote_insert_form')
  end

  def login
  end

  def login_post
    @voting_area = VotingArea.authenticate params[:username], params[:password]
    if @voting_area
      session[:voting_area_id] = @voting_area.id
    else
      flash[:alert] = "Sisäänkirjautuminen epäonnistui."
      session[:voting_area_id] = nil
      redirect_to login_voting_area_path and return
    end

    redirect_to voting_area_path
  end

  def mark_ready
    @voting_area.ready!
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

  def assign_voting_area
    @voting_area = VotingArea.find_by_id session[:voting_area_id]
  end

end
