# encoding: utf-8
class Advocates::AlliancesController < AdvocatesController

  def index
    @alliances = current_advocate_user.electoral_alliances
  end

  def show
    @alliance = current_advocate_user.electoral_alliances.find(params[:id])
  end

  def new
    @alliance = current_advocate_user.electoral_alliances.build
  end

  def create
    @alliance = current_advocate_user.electoral_alliances.build(params[:electoral_alliance])

    if @alliance.save
      flash[:notice] = "Vaaliliitto luotu!"
      redirect_to advocates_alliance_path(@alliance)
    else
      flash[:alert] = "Vaaliliiton luominen epäonnistui."
      render :action => :new
    end
  end
end
