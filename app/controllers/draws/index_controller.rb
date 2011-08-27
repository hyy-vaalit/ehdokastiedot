class Draws::IndexController < DrawsController

  def index
    @count_of_coalition_draws = CoalitionDraw.count
    @count_of_alliance_draws = AllianceDraw.count
    @count_of_candidate_draws = CandidateDraw.count

    @status_of_coalition_draws = REDIS.get('coalition_draw_status')
    @status_of_alliance_draws = REDIS.get('alliance_draw_status')
    @status_of_candidate_draws = REDIS.get('candidate_draw_status')
  end

end
