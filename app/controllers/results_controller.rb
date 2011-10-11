# coding: UTF-8
class ResultsController < ApplicationController

  before_filter :authenticate_admin_user!
  before_filter :authorize

  layout "outside_activeadmin"

  def index
    @results = Result.for_listing

  end

  def show
    @chart = params[:chart] # alliances || coalitions (defualt)
    @result = ResultDecorator.find(params[:id])
  end

  protected

  def authorize
    authorize! :manage, :results
  end

end
