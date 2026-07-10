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
      flash[:notice] = t("flashes.saved")
    else
      flash[:alert] = t("flashes.save_failed")
      render :action => :edit and return
    end

    redirect_to advocates_alliance_path(@alliance)
  end

  def create
    @alliance = current_advocate_user.electoral_alliances.build(alliance_params)

    if @alliance.save
      flash[:notice] = t(".created")
    else
      flash[:alert] = t(".create_failed")
      render :action => :new and return
    end

    redirect_to advocates_alliance_path(@alliance)
  end

  protected

  # Return either
  # - alliance of mine (which is not linked to coalition yet)
  # - or, for read-only :show, alliance through AdvocateTeam (user A is
  #   viewing alliance of user B of the same team). Team membership grants
  #   read access only: edit/update resolve strictly through my own alliances.
  def find_alliance
    @alliance = current_advocate_user.electoral_alliances.find_by(id: params[:id])

    if @alliance.nil? && action_name == "show" && current_advocate_user.advocate_team.present?
      @alliance = current_advocate_user.advocate_team.electoral_alliances.find_by(id: params[:id])
    end

    if @alliance.nil?
      flash.alert = t("flashes.alliance_not_found")
      redirect_to advocates_alliances_path
    end
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
