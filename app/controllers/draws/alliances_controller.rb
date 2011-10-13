class Draws::AlliancesController < DrawsController
  def show
    @draw = AllianceDraw.find(params[:id])
  end

  def update
    draw = AllianceDraw.find(params[:id])
    draw.give_order!(:coalition_draw_order, params[:draw_order])
    redirect_to draws_path
  end

end
