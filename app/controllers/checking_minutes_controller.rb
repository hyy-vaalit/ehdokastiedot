class CheckingMinutesController < ApplicationController

  skip_authorization_check

  before_filter :authenticate
  before_filter :check_if_ready, :except => :fixes

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

  def fixes
    @voting_areas = VotingArea.all
  end

  def ready
    Delayed::Job.enqueue(DrawArrangeJob.new)
    REDIS.set('checking_minutes_ready', true)
    redirect_to checking_minutes_path
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      REDIS.get('checking_minutes_username') && REDIS.get('checking_minutes_password') && username == REDIS.get('checking_minutes_username') && password == REDIS.get('checking_minutes_password')
    end
  end

  def check_if_ready
    if REDIS.get('checking_minutes_ready')
      redirect_to fixes_checking_minutes_path, :notice => 'Tarkastuslaskenta on valmis'
      return
    end
  end

end
