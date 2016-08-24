class Advocates::CandidatesController < AdvocatesController
  respond_to :html, :json, :only => :update

  before_filter :find_alliance
  authorize_resource # After resource has been loaded

  def new
    @candidate = Candidate.new
    @candidate.electoral_alliance = @alliance
  end

  def index
    redirect_to advocates_alliance_url(@alliance)
  end

  def edit
    @candidate = @alliance.candidates.find(params[:id])
  end

  def show
    raise "Not implemented"
  end

  def update
    @candidate = @alliance.candidates.find(params[:id])

    if @candidate.log_and_update_attributes(candidate_params)
      flash[:notice] = "Muutokset tallennettu."
    else
      flash[:alert] = "Muutosten tallentaminen epäonnistui!"
      render :action => :edit and return
    end

    respond_with(@alliance) do |format|
      format.html { redirect_to advocates_alliance_path(@alliance) }
    end
  end

  def create
    @candidate = @alliance.candidates.build(candidate_params)

    if @candidate.save
      flash[:notice] = "Ehdokas luotu!"
      redirect_to advocates_alliance_path(@alliance)
    else
      flash[:alert] = "Ehdokkaan luominen epäonnistui."
      render :action => :new
    end
  end

  def destroy
    @candidate = @alliance.candidates.find(params[:id])

    if @candidate.destroy
      flash[:notice] = "Ehdokas poistettiin."
      redirect_to advocates_alliance_path(@alliance)
    else
      flash[:alert] = "Ehdokkaan poistaminen epäonnistui."
      render :action => :edit
    end
  end

  protected

  # Ensure current user has access to the target alliance by finding it through
  # the relation (not directly from `ElectoralAlliance`).
  def find_alliance
    @alliance = current_advocate_user
      .electoral_alliances
      .find(params[:alliance_id])
  end

  def candidate_params
    params
      .require(:candidate)
      .permit(
        :lastname,
        :firstname,
        :social_security_number,
        :faculty_id,
        :address,
        :postal_information,
        :phone_number,
        :email,
        :candidate_name,
        :notes,
        :numbering_order_position
      )
  end

end
