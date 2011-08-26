class DrawsController < ApplicationController

  before_filter :authorize_draws

  private

  def authorize_draws
    authorize! :manage, :drawings
  end

end
