class Manage::CandidatesController < ManageController
  def index
    @candidates = Candidate.for_listing

    respond_to do |format|
      format.html { }
      format.csv  { render :layout => false }
    end
  end

  def reduced
    @candidates = Candidate.for_listing

    respond_to do |format|
      format.csv  { render :layout => false }
    end
  end

end
