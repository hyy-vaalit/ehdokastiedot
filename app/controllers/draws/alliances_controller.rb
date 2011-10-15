class Draws::AlliancesController < DrawsController
  def show
    @draw = AllianceDraw.find(params[:id])
  end

  def update
    draw = AllianceDraw.find(params[:id])
    draw.give_order!(:alliance_draw_order, params[:draw_order], automatically?)

    redirect_to draws_path(:anchor => "draw_#{draw.identifier}")
  end

end
