class ListingsController < ApplicationController

  before_filter :authorize_listings

  def same_ssn
    @ssn_and_candidates = Candidate.all.group_by{|g| g.social_security_number}.to_a.select{|x| x.last.count > 1}
  end

  def simple
    @candidates = Candidate.all
  end

  def proportional_order
    @coalition_count = ElectoralCoalition.all.count
    @alliance_count = ElectoralAlliance.all.count - ElectoralAlliance.not_real.count
    @allianceless_candidates = Candidate.without_electoral_alliance.count
    @candidates_to_select = Configuration.find_by_key('candidates_to_select').value.to_i
    @right_to_vote = Configuration.find_by_key('right_to_vote').value.to_i
    @votes_given = Configuration.find_by_key('total_vote_count').value.to_i
    @votes_accepted = Vote.ready.count
    @voting_percentage = (100 * @votes_given / @right_to_vote).to_i
    @calculated_votes = Vote.calculated
    @candidates = Candidate.order('coalition_proportional desc, alliance_proportional desc').all
  end

  def showdown
    @voting_areas = VotingArea.all
  end

  def showdown_post
    ids = params[:takewith]
    if ids
      VotingArea.take! ids
      Proportionals.calculus!
    end
    redirect_to showdown_listings_path
  end

  def lulz
    raise 'hoptoad-test'.inspect
  end

  private

  def authorize_listings
    authorize! :listings, @current_admin_user
  end

end
