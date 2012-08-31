# coding: UTF-8
class VotingAreasController < ApplicationController

  skip_authorization_check

  before_filter :authenticate, :except => [:login, :login_post]

  before_filter :assign_voting_area, :except => [:login, :login_post]

  def show
  end

  def create
    @voting_area.create_votes_from(params[:votes], :use_fixed_amount => false)

    flash[:invalid_candidate_numbers] = @voting_area.errors[:invalid_candidate_numbers] if @voting_area.errors[:invalid_candidate_numbers]
    redirect_to voting_area_path(:anchor => 'submit-votes')
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

  def mark_submitted
    @voting_area.submitted!
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
    @voting_area = VotingArea.find(session[:voting_area_id])
  end

end
