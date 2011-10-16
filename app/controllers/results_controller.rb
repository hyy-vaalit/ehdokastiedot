# coding: UTF-8
class ResultsController < ApplicationController

  before_filter :authenticate_admin_user!
  before_filter :authorize

  layout "outside_activeadmin"

  def index
    @results = Result.for_listing

  end

  # The text format of the result is used for displaying a temporary result when executing the drawings.
  # That should be the only purpose (except for viewing the result in development environment).
  # Rendering the result view is *slow* and may result to request timeout. For any other production purposes,
  # use the file which is stored in S3.
  def show
    @chart = params[:chart] # alliances || coalitions (defualt)
    @result = ResultDecorator.find(params[:id])

    respond_to do |format|
      format.html { }
      format.text { render :partial => "result", :locals => { :result_decorator => @result} } # This should be used with caution!
    end
  end

  protected

  def authorize
    authorize! :manage, :results
  end

end
