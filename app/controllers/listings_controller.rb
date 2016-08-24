class ListingsController < ApplicationController

  before_filter :authorize_listings

  def same_ssn
    @ssn_and_candidates = Candidate.all.group_by{|g| g.social_security_number}.to_a.select{|x| x.last.count > 1}
  end

  def simple
    @candidates = Candidate.for_listing
  end

  def showdown
    @voting_areas = VotingArea.for_showdown
  end

  def showdown_post
    # REFACTOR: Controller is wrong place for this
    VotingArea.transaction do
      params[:mark_ready].each do |voting_area_id|
        VotingArea.find(voting_area_id).ready!
      end

      Delayed::Job.enqueue(CreateResultJob.new)
    end

    flash[:notice] = "Äänestysalue otettu laskentaan."
    redirect_to showdown_listings_path
  end

  private

  def authorize_listings
    authorize! :listings, @current_admin_user
  end

end
