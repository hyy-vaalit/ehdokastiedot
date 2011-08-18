module ResultPage

  def self.render_results
    coalition_count = ElectoralCoalition.all.count
    alliance_count = ElectoralAlliance.all.count - ElectoralAlliance.not_real.count
    allianceless_candidates = Candidate.without_electoral_alliance.count
    candidates_to_select = Configuration.find_by_key('candidates_to_select').value.to_i
    right_to_vote = Configuration.find_by_key('right_to_vote').value.to_i
    votes_given = Configuration.find_by_key('total_vote_count').value.to_i
    votes_accepted = Vote.ready.sum(:vote_count)
    voting_percentage = (100 * votes_given / right_to_vote).to_i
    calculated_votes = Vote.calculated
    candidates = Candidate.order('coalition_proportional desc, alliance_proportional desc').all
    av = ActionView::Base.new(Rails.configuration.view_path)
    output = av.render :partial => 'listings/result', :format => :html, :locals => {
      :coalition_count => coalition_count,
      :alliance_count => alliance_count,
      :allianceless_candidates => allianceless_candidates,
      :candidates_to_select => candidates_to_select,
      :right_to_vote => right_to_vote,
      :votes_given => votes_given,
      :votes_accepted => votes_accepted,
      :voting_percentage => voting_percentage,
      :calculated_votes => calculated_votes,
      :candidates => candidates
    }
    REDIS.set 'result_output', output
  end

end
