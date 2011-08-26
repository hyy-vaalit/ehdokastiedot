module Draws::AlliancesHelper

  def get_draw_candidate_from_alliance drawing
    drawing.electoral_alliance.candidates.selection_order[drawing.position_in_alliance].candidate_number
  end

end
