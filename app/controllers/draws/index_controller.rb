class Draws::IndexController < DrawsController

  def index
    @count_of_coalition_draws = CoalitionDraw.count
    @count_of_alliance_draws = AllianceDraw.count
    @count_of_candidate_draws = CandidateDraw.count

    @status_of_coalition_draws = false
    @status_of_alliance_draws = false
    @status_of_candidate_draws = false
  end

end
