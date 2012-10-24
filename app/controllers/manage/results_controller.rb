# coding: UTF-8
class Manage::ResultsController < ManageController
  respond_to :json

  def index
    @results = Result.for_listing
  end

  # The calculated format of the result is used for displaying a temporary result when executing the drawings.
  # It should be the only purpose (except for viewing the result in development environment).
  # Rendering the result view is *slow* and may result to request timeout. For any other production purposes,
  # use the file which is stored in S3.
  def show
    @result = ResultDecorator.find(params[:id])

    respond_to do |format|
      format.json { render :locals => {:result => @result} }
      format.html { render :partial => "result", :locals => { :result_decorator => @result} }
    end
  end

  def publish
    result_publisher = ResultPublisher.find(params[:result_id])

    if result_publisher.publish!
      flash[:notice] = "Vaalitulos jonossa julkaistavaksi."
    else
      flash[:error] = "Vaalituloksen julkaisu epäonnistui."
    end

    redirect_to manage_results_path
  end

  protected

  def authorize_this!
    authorize! :manage, :results
  end

end
