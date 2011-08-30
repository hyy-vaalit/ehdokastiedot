module ResultPage
  include ListingsHelper

  def self.render_results
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
    data = {
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

    puts "ResultPage.render_results rendering html"
    render_content('html', 'result_output', data)
    puts "ResultPage.render_results rendering text"
    render_content('text', 'result_text_output', data)
  end

  def self.render_final_results
    coalition_count = ElectoralCoalition.all.count
    alliance_count = ElectoralAlliance.all.count - ElectoralAlliance.not_real.count
    allianceless_candidates = Candidate.without_electoral_alliance.count
    candidates_to_select = REDIS.get('candidates_to_select').to_i
    right_to_vote = REDIS.get('right_to_vote').to_i
    votes_given = REDIS.get('total_vote_count').to_i
    votes_accepted = Vote.fixed.sum(:vote_count)
    voting_percentage = (100 * votes_given / right_to_vote).to_i
    calculated_votes = Vote.calculated
    candidates = Candidate.selection_order.all

    data = {
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

    render_content('html', 'final_result_output', data, true)
    render_content('text', 'final_result_text_output', data, true)
  end

  def self.render_content(format, name, data, final=false)
    partial = final ? 'final_result' : 'result'
    av = ApplicationController.view_context_class.new(Rails.configuration.view_path)
    output = av.render :partial => "results/#{partial}.#{format}.erb", :locals => data
    puts "ResultPage.render_results starting to set rendered result to REDIS"
    puts "output is #{output.size} long"
    REDIS.set name, output
    puts "ResultPage.render_results finished setting rendered result to REDIS"
  end

end
