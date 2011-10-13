class Draws::CoalitionsController < DrawsController

  def show
    @draw = CoalitionDraw.find(params[:id])
  end

  def update
    draw = CoalitionDraw.find(params[:id])
    draw.give_order!(:coalition_draw_order, params[:draw_order])
    redirect_to draws_path
  end
end
