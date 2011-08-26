class Draws::AlliancesController < DrawsController

  def index
    @alliance_draws = AllianceDraw.all
  end

  def edit
    @alliance_draw = AllianceDraw.find_by_id params[:id]
  end

  def update
    @draw = AllianceDraw.find_by_id params[:id]
    params[:alliance_drawing].sort{|x,y| x.last<=>y.last}.each do |id, value|
      drawing = @draw.alliance_drawings.find_by_id(id)
      drawing.update_attribute :position_in_draw_position, value
    end
    @draw.update_attribute :drawed, true
    redirect_to draws_alliances_path(:anchor => "draw_#{@draw.id}")
  end

end
