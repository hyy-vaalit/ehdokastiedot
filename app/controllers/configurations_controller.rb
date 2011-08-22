class ConfigurationsController < ApplicationController

  before_filter :authorize_configurations

  def index
    @total_vote_count = REDIS.get 'total_vote_count'
    @right_to_vote = REDIS.get 'right_to_vote'
    @candidates_to_select = REDIS.get 'candidates_to_select'
    @spare_candidates_to_select = REDIS.get 'spare_candidates_to_select'
    @mailaddress = REDIS.get 'mailaddress'
  end

  def update
    REDIS.set params[:id], params[:value]
    redirect_to configurations_path
  end

  private

  def authorize_configurations
    authorize! :configurations, @current_admin_user
  end

end
