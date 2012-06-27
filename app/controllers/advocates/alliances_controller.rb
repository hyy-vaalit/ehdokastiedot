# encoding: utf-8
class Advocates::AlliancesController < AdvocatesController

  before_filter :find_alliance, :only => [:show, :edit, :update]

  def index
    @alliances = current_advocate_user.electoral_alliances
  end

  def new
    @alliance = current_advocate_user.electoral_alliances.build
  end

  def show
  end

  def edit
  end

  def update
    if @alliance.update_attributes(params[:electoral_alliance])
      flash[:notice] = "Muutokset tallennettu."
    else
      flash[:alert] = "Muutosten tallentaminen epäonnistui!"
      render :action => :edit and return
    end

    redirect_to advocates_alliance_path(@alliance)
  end

  def create
    @alliance = current_advocate_user.electoral_alliances.build(params[:electoral_alliance])

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
end
