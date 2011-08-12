class SessionsController < ApplicationController

  skip_authorization_check

  def new
  end

  def create
    advocate = AdvocateUser.authenticate(params[:email], params[:password])
    if advocate
      session[:advocate] = advocate.id
      redirect_to advocate_path
    else
      redirect_to new_advocate_session_path
    end
  end

end
