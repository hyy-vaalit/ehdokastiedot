module ResultPage
  include ListingsHelper

  def self.render_results
    render_content('html', 'result_output')
    render_content('text', 'result_text_output')
  end

  def self.render_content(format, name)
    coalition_count = ElectoralCoalition.all.count
    alliance_count = ElectoralAlliance.all.count - ElectoralAlliance.not_real.count
    allianceless_candidates = Candidate.without_electoral_alliance.count
    candidates_to_select = REDIS.get('candidates_to_select').to_i
    right_to_vote = REDIS.get('right_to_vote').to_i
    votes_given = REDIS.get('total_vote_count').to_i
    votes_accepted = Vote.ready.sum(:vote_count)
    voting_percentage = (100 * votes_given / right_to_vote).to_i
    calculated_votes = Vote.calculated
    candidates = Candidate.selection_order.all

    av = ApplicationController.view_context_class.new(Rails.configuration.view_path)
    output = av.render :partial => "listings/result.#{format}.erb", :locals => {
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
    REDIS.set name, output
  end

end
