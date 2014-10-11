module ApplicationHelper
  def alliance_ready?(alliance)
    alliance.candidates.count == alliance.expected_candidate_count
  end

  def chart_address(result, chart_type)
    base_url = Vaalit::Results::PUBLIC_RESULT_URL
    name = chart_type == :candidates ? "candidates" : "result"

    "#{base_url}/#{chart_type}.html?json=#{result.filename('.json', name)}"
  end

  def voting_right_class(can_vote)
    if can_vote
      "can-vote"
    else
      "has-voted"
    end
  end
end
