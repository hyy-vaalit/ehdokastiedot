module Draws::IndexHelper

  def coalition_draws_status(status)
    if status
      'valmis'
    else
      link_to 'kesken', draws_coalitions_path
    end
  end

  def alliance_draws_status(status)
    if status
      'valmis'
    else
      link_to 'kesken', draws_alliances_path
    end
  end

  def candidate_draws_status(status)
    if status
      'valmis'
    else
      link_to 'kesken', draws_candidates_path
    end
  end

end
