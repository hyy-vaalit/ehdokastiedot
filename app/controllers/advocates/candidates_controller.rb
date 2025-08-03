class Advocates::CandidatesController < AdvocatesController
  respond_to :html, :json, :only => :update

  before_action :find_alliance

  authorize_resource :electoral_alliance

  def new
    @candidate = Candidate.new
    @candidate.electoral_alliance = @alliance

    authorize! :create, @candidate
  end

  def index
    redirect_to advocates_alliance_url(@alliance)
  end

  def edit
    @candidate = @alliance.candidates.find(params[:id])

    authorize! :edit, @candidate
  end

  def show
    raise "Not implemented"
  end

  # Updates Candidate attributes (html form) and Candidate numbering order (xhr/json)
  def update
    @candidate = @alliance.candidates.find(params[:id])

    authorize! :update, @candidate

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

    authorize! :create, @candidate

    if @candidate.save
      flash[:notice] = "Ehdokas luotu!"
      redirect_to advocates_alliance_path(@alliance)
    else
      flash[:alert] = "Ehdokkaan luominen epäonnistui."
      render :action => :new
    end
  end

  def confirm_alliance
    candidate = @alliance.candidates.find(params[:candidate_id])

    if candidate.confirm_alliance!
      flash.notice = "Vaaliliitto vahvistettu!"
    else
      flash.error = "Vaaliliittoon vahvistaminen epäonnistui: #{candidate.errors.full_messages}"
    end

    redirect_to advocates_alliance_path(@alliance)
  end

  protected

  # Advocate can only edit Candidates which belong to Alliance they manage.
  # AdvocateTeam membership does not grant access to modify the Alliance or its Candidates.
  # Advocate can, however, view Candidates of belonging to any of the AdvocateTeam Alliances
  # in AlliancesController#show.
  def find_alliance
    @alliance = current_advocate_user
      .electoral_alliances
      .find(params[:alliance_id])
  rescue ActiveRecord::RecordNotFound
    flash.alert = "Pyydettyä kohdetta ei löytynyt tai sinulla ei ole oikeuksia pyydettyyn toimintoon. Vaaliliiton edustaja voi muokata vain oman vaaliliittonsa ehdokastietoja."
    redirect_to advocates_alliance_path(params[:alliance_id]) and return
  end

  def candidate_params
    params
      .require(:candidate)
      .permit(
        :lastname,
        :firstname,
        :student_number,
        :faculty_id,
        :address,
        :postal_code,
        :postal_city,
        :phone_number,
        :email,
        :candidate_name,
        :notes,
        :numbering_order_position
      )
  end
end
