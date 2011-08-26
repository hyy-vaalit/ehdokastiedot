class Draws::CandidatesController < DrawsController

  def index
    @candidate_draws = CandidateDraw.all
  end

  def edit
    @candidate_draw = CandidateDraw.find_by_id params[:id]
  end

end
