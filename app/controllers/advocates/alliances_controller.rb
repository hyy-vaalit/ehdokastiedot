class Advocates::AlliancesController < AdvocatesController

  before_action :find_alliance, :only => [:show, :edit, :update]
  before_action :nav_paths, :only => [:index, :show]

  authorize_resource :electoral_alliance, :parent => false # Conf needed because ElectoralAlliance != Alliance. Without ":parent => false" authorization is not effective.

  def index
    @advocate_team = current_advocate_user&.advocate_team
    @team_alliances = @advocate_team&.electoral_coalition&.electoral_alliances&.by_numbering_order || []
    @alliances_without_coalition = current_advocate_user.electoral_alliances.by_numbering_order - @team_alliances
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
    if @alliance.update(alliance_params)
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

  # Return either
  # - alliance of mine (which is not linked to coalition yet)
  # - or alliance through AdvocateTeam (user A is viewing alliance of user B of the same team)
  def find_alliance
    @alliance = current_advocate_user.electoral_alliances.find_by(id: params[:id])

    if @alliance.nil? && current_advocate_user.advocate_team.present?
      @alliance = current_advocate_user.advocate_team.electoral_alliances.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    flash.alert = "Pyydettyä vaaliliittoa ei löytynyt tai sinulla ei ole oikeuksia siihen."
    redirect_to advocates_alliances_path
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
        :expected_candidate_count,
        :invite_code
      )
  end
end
