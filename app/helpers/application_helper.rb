module ApplicationHelper
  def alliance_ready?(alliance)
    alliance.candidates.count == alliance.expected_candidate_count
  end

  def current_haka_user
    @current_haka_user
  end

  def current_advocate_user
    current_haka_user&.advocate_user
  end
end
