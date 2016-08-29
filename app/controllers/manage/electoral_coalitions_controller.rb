class Manage::ElectoralCoalitionsController < ManageController

  # List Coalitions for CSV Export.
  def index
    @coalitions = ElectoralCoalition.by_numbering_order

    respond_to do |format|
      format.csv  { render :layout => false }
    end
  end

  protected

  def authorize_this!
    authorize! :coalitions, @current_admin_user
  end
end
