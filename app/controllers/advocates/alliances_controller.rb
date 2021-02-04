class Advocates::AlliancesController < AdvocatesController

  before_action :find_alliance, :only => [:show, :edit, :update]
  before_action :nav_paths, :only => [:index, :show]

  authorize_resource :electoral_alliance, :parent => false # Conf needed because ElectoralAlliance != Alliance. Without ":parent => false" authorization is not effective.

  def index
    @alliances = current_advocate_user.electoral_alliances.by_numbering_order
  end

  def new
    @alliance = current_advocate_user.electoral_alliances.build
  end

  def show
    if params[:isolatin]
      @encoding = "ISO-8859-1"
    else
      @encoding = "UTF-8"
    end

    respond_to do |format|
      format.html { }
      format.csv  { render :layout => false }
    end
  end

  def edit
  end

  def update
    if @alliance.update!(alliance_params)
      flash[:notice] = "Muutokset tallennettu."
    else
      flash[:alert] = "Muutosten tallentaminen epäonnistui!"
      render :action => :edit and return
    end

    redirect_to advocates_alliance_path(@alliance)
  end

  def create
    @alliance = current_advocate_user.electoral_alliances.build(alliance_params)

    if @alliance.save
      flash[:notice] = "Vaaliliitto luotu!"
    else
      flash[:alert] = "Vaaliliiton luominen epäonnistui."
      render :action => :new and return
    end

    redirect_to advocates_alliance_path(@alliance)
  end

  protected

  def find_alliance
    @alliance = current_advocate_user.electoral_alliances.find(params[:id])
  end

  def nav_paths
    @_nav_paths = [{"Kaikki vaaliliitot" => advocates_alliances_path}]
  end

  def alliance_params
    params
      .require(:electoral_alliance)
      .permit(
        :name,
        :shorten,
        :expected_candidate_count)
  end
end
