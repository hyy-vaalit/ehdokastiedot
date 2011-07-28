class VotingAreasController < ApplicationController

  skip_authorization_check

  def show
  end

  def login
  end

  def login_post
    redirect_to voting_area_path
  end

end
