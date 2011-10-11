# coding: UTF-8
class ResultsController < ApplicationController

  before_filter :authenticate_admin_user!
  before_filter :authorize

  layout "outside_activeadmin"

  def index
    @results = ResultDecorator.for_listing

  end


  protected

  def authorize
    authorize! :manage, :results
  end

end
