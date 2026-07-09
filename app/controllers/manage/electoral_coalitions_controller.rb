class Manage::ElectoralCoalitionsController < ManageController

  # List Coalitions for CSV Export.
  def index
    @coalitions = ElectoralCoalition.by_numbering_order

    respond_to do |format|
      format.csv  { render :layout => false }
    end
  end

end
