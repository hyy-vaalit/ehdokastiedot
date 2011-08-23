class ListingsController < ApplicationController

  before_filter :authorize_listings

  def same_ssn
    @ssn_and_candidates = Candidate.all.group_by{|g| g.social_security_number}.to_a.select{|x| x.last.count > 1}
  end

  def simple
    @candidates = Candidate.all
  end

  def showdown
    @voting_areas = VotingArea.all
  end

  def showdown_post
    ids = params[:takewith]
    if ids
      VotingArea.take! ids
      Delayed::Job.enqueue(VoteCalculusJob.new(ids))
    end
    redirect_to showdown_listings_path
  end

  def has_fixes
    @coalitions = ElectoralCoalition.all
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
