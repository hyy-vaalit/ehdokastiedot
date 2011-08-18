class VoteCalculusJob < Struct.new(:voting_area_ids)

  def perform
    Proportionals.calculus!
    voting_area_ids.each do |id|
      VotingArea.find_by_id(id).mark_as_calculated!
    end
    ResultPage.render_results
  end

end
