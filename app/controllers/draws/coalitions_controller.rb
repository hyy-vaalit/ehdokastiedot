class Draws::CoalitionsController < DrawsController

  def index
    @coalition_draws = CoalitionDraw.all
  end

end
