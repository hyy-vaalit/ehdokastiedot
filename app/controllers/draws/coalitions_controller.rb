class Draws::CoalitionsController < DrawsController

  def index
    @coalition_draws = CoalitionDraw.all
  end

  def edit
    @coalition_draw = CoalitionDraw.find_by_id params[:id]
  end

end
