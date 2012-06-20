class Advocates::AlliancesController < AdvocatesController

  def index
    @alliances = current_advocate_user.electoral_alliances
  end

  def show
    @alliance = current_advocate_user.electoral_alliances.find(params[:id])
  end
end
