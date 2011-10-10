class ListingsController < ApplicationController

  before_filter :authorize_listings

  def same_ssn
    @ssn_and_candidates = Candidate.all.group_by{|g| g.social_security_number}.to_a.select{|x| x.last.count > 1}
  end

  def simple
    @candidates = Candidate.by_alliance.all
  end

  def showdown
    @voting_areas = VotingArea.for_showdown
  end

  def showdown_post
    params[:mark_ready].each do |voting_area_id|
      VotingArea.find(voting_area_id).ready!
    end

    Delayed::Job.enqueue(CreateResultJob.new)
    redirect_to showdown_listings_path
  end

  def has_fixes
    @coalitions = ElectoralCoalition.all.select{|coalition| coalition.has_fix_needing_candidates?}
  end

  def has_fixes_post
    fix = DataFix.find_by_id params[:fix_id]
    if fix
      method = params[:method]
      if method == 'accept'
        fix.accept!
        render :json => fix
        return
      elsif method == 'reject'
        fix.reject!
        render :json => fix
        return
      end
    end
    raise "error"
  end

  def lulz
    raise 'hoptoad-test'.inspect
  end

  private

  def authorize_listings
    authorize! :listings, @current_admin_user
  end

end
