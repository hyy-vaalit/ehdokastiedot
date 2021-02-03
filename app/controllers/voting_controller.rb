class VotingController < ApplicationController

  before_action :authenticate_voting_area_user!

  before_action :authorize_this

  protected

  def authorize_this
    if current_user.instance_of? AdminUser
      flash[:error] = "Kirjaa pääkäyttäjä ulos ennen kuin menet äänestysalueelle."
    end

    authorize! :access, :voting
  end

end
