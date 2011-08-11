class SessionsController < ApplicationController

  skip_authorization_check

  def new
  end

  def create
    advocate = AdvocateUser.authenticate(params[:email], params[:password])
    session[:advocate] = advocate.id if advocate
    redirect_to advocate_path
  end

end
