module ApplicationHelper
  def alliance_ready?(alliance)
    alliance.candidates.count == alliance.expected_candidate_count
  end

  def chart_address(result, chart_type)
    base_url = Vaalit::Results::PUBLIC_RESULT_URL
    name = chart_type == :candidates ? "candidates" : "tulos"

    "#{base_url}/#{chart_type}.html?json=#{result.filename('.json', name)}"
  end
end
