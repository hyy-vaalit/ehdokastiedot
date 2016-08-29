class Manage::CandidatesController < ManageController

  # List Candidates for CSV Export.
  # Please note: Formatting is done in the view.
  def index
    @candidates = Candidate.for_listing

    respond_to do |format|
      format.csv  { render :layout => false }
    end
  end

  protected

  def authorize_this!
    authorize! :candidates, @current_admin_user
  end
end
