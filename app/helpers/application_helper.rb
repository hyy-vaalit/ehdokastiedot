module ApplicationHelper
  def alliance_ready?(alliance)
    alliance.candidates.count == alliance.expected_candidate_count
  end

  def chart_address(result, chart_type)
    base_url = Vaalit::Results::PUBLIC_RESULT_URL

    "#{base_url}/#{chart_type}.html?json=#{result.filename('.json')}"
  end
end
