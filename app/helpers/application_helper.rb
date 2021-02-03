module ApplicationHelper
  def alliance_ready?(alliance)
    alliance.candidates.count == alliance.expected_candidate_count
  end
end
