class Manage::ChartsController < ManageController

  def show
    @result = ResultDecorator.find(params[:result_id])

    render params[:type], :locals => { :result => @result}
  end

  def authorize_this!
    authorize! :manage, :results
  end

end
