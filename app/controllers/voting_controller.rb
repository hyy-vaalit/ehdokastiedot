class VotingController < ApplicationController

  before_filter :authenticate_voting_area_user!

  before_filter :authorize_this

  protected

  def authorize_this
    authorize! :access, :voting
  end

end
