class AdvocatesController < ApplicationController

  before_filter :authenticate_advocate_user!

  skip_authorization_check # FIXME

  def index
    render :text =>  "JES AdvocatesController#index, devise_controller: #{devise_controller?}, current_user: #{current_advocate_user.email}"
  end

end
