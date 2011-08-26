class Draws::AlliancesController < DrawsController

  def index
    @alliance_draws = AllianceDraw.all
  end

  def edit
    @alliance_draw = AllianceDraw.find_by_id params[:id]
  end

end
