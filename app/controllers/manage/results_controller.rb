# coding: UTF-8
class Manage::ResultsController < ManageController

  def index
    @results = Result.for_listing

  end

  # The text format of the result is used for displaying a temporary result when executing the drawings.
  # That should be the only purpose (except for viewing the result in development environment).
  # Rendering the result view is *slow* and may result to request timeout. For any other production purposes,
  # use the file which is stored in S3.
  def show
    @chart = params[:chart] # alliances || candidates || coalitions (default)
    @result = ResultDecorator.find(params[:id])

    respond_to do |format|
      format.html { }
      format.text { render :partial => "result", :locals => { :result_decorator => @result} } # This should be used with caution!
    end
  end

  protected

  def authorize_this!
    authorize! :manage, :results
  end

end
