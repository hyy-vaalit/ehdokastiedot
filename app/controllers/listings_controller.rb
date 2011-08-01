class ListingsController < ApplicationController

  before_filter :authorize_listings

  def same_ssn
    @ssn_and_candidates = Candidate.all.group_by{|g| g.social_security_number}.to_a.select{|x| x.last.count > 1}
  end

  def simple
    @candidates = Candidate.all
  end

  def proportional_order
    @candidates = Candidate.order('coalition_proportional desc, alliance_proportional desc').all
  end

  private

  def authorize_listings
    authorize! :listings, @current_admin_user
  end

end
