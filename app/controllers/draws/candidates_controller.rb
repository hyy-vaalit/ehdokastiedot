class Draws::CandidatesController < DrawsController

  def index
    @candidate_draws = CandidateDraw.all
  end

end
