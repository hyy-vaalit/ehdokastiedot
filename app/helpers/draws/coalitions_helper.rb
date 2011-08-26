module Draws::CoalitionsHelper

  def get_draw_candidate_from_coalition drawing
    Candidate.from_coalition(drawing.electoral_coalition).selection_order[drawing.position_in_coalition].candidate_number
  end

end
