class Draws::CoalitionsController < DrawsController

  def index
    @coalition_draws = CoalitionDraw.all
  end

  def edit
    @coalition_draw = CoalitionDraw.find_by_id params[:id]
  end

  def update
    @draw = CoalitionDraw.find_by_id params[:id]
    params[:coalition_drawing].sort{|x,y| x.last<=>y.last}.each do |id, value|
      drawing = @draw.coalition_drawings.find_by_id(id)
      drawing.update_attribute :position_in_draw_position, value
    end
    @draw.update_attribute :drawed, true
    redirect_to draws_coalitions_path(:anchor => "draw_#{@draw.id}")
  end

end
