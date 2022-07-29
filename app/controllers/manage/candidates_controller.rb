class Manage::CandidatesController < ManageController
  def index
    @candidates = Candidate.for_listing

    respond_to do |format|
      format.html { }
      format.csv  { render :layout => false }
    end
  end

  protected

  def authorize_this!
    authorize! :candidates, @current_admin_user
  end
end
