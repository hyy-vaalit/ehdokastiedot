class CheckingMinutesController < ApplicationController

  before_filter :authorize_minutes

  def index
    @voting_areas = VotingArea.all
  end

  def show
    @candidates = Candidate.includes(:electoral_alliance).all
    @voting_area = VotingArea.find_by_id params[:id]
  end

  def edit
    @voting_area = VotingArea.find_by_id params[:id]
  end

  def update
    @voting_area = VotingArea.find_by_id params[:id]
    begin
      @voting_area.give_fix_votes! params[:votes]
    rescue => e
      flash[:errors] = e.message
    end
    redirect_to edit_checking_minute_path(@voting_area.id, :anchor => 'vote_fix_form')
  end

  private

  def authorize_minutes
    authorize! :minutes, @current_admin_user
  end

end
