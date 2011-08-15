class CandidatesController < ApplicationController

  skip_authorization_check

  before_filter :authenticate_advocate, :authorize_for_candidate

  def show
  end

  def report_fixes
    df = @candidate.data_fixes.create! :field_name => params[:field], :old_value => @candidate.send(params[:field]), :new_value => params[:new_value]
    render :json => df
  end

  private

  def authenticate_advocate
    @advocate = AdvocateUser.find_by_id(session[:advocate])
    redirect_to new_advocate_session_path unless @advocate
  end

  def authorize_for_candidate
    @candidate = Candidate.find_by_id(params[:id])
    redirect_to advocate_path unless @candidate.electoral_alliance.advocate_user == @advocate
  end

end
