class CandidatesController < ApplicationController

  skip_authorization_check

  def show
    @candidate = Candidate.find_by_id params[:id]
  end

  def report_fixes
    candidate = Candidate.find_by_id(params[:id])
    df = candidate.data_fixes.create! :field_name => params[:field], :old_value => candidate.send(params[:field]), :new_value => params[:new_value]
    render :json => df
  end


end
