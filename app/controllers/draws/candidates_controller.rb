class Draws::CandidatesController < DrawsController

  def index
    @candidate_draws = CandidateDraw.all
  end

  def edit
    @candidate_draw = CandidateDraw.find_by_id params[:id]
  end

  def update
    @draw = CandidateDraw.find_by_id params[:id]
    params[:candidate_drawing].sort{|x,y| x.last<=>y.last}.each do |id, value|
      drawing = @draw.candidate_drawings.find_by_id(id)
      drawing.update_attribute :position_in_draw_position, value
    end
    @draw.update_attribute :drawed, true
    redirect_to draws_candidates_path(:anchor => "draw_#{@draw.id}")
  end

end
