class Manage::ElectoralAlliancesController < ManageController

  # List Alliances for CSV Export.
  def index
    @alliances = ElectoralAlliance.by_numbering_order

    respond_to do |format|
      format.csv  { render :layout => false }
    end
  end

end
