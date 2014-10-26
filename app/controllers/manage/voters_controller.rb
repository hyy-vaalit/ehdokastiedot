class Manage::VotersController < ManageController

  # List Voters for CSV Export.
  # Please note: Formatting is done in the view.
  def index
    @voters = Voter.for_export

    respond_to do |format|
      format.html { }
      format.csv  { render :layout => false }
    end
  end

  protected

  def authorize_this!
    authorize! :manage, :voters
  end
end
