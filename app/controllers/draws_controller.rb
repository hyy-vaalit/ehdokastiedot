class DrawsController < ApplicationController

  before_filter :authorize_draws
  before_filter :check_draw_status

  private

  def authorize_draws
    authorize! :manage, :drawings
  end

  def check_draw_status
    status = REDIS.get('drawing_status')
    redirect_to draws_path unless status and status == 'ready'
  end

end
