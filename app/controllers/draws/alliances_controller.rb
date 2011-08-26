class Draws::AlliancesController < DrawsController

  def index
    @alliance_draws = AllianceDraw.all
  end

end
