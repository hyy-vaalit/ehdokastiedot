module ApplicationHelper
  # Current page in another language, keeping query params (e.g. invite_code).
  def locale_switch_path(locale)
    url_for(request.query_parameters.symbolize_keys.except(:locale).merge(locale: locale))
  end

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
