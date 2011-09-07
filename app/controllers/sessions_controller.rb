# coding: UTF-8
class SessionsController < ApplicationController

  skip_authorization_check

  layout "outside_activeadmin"

  def new
  end

  def create
    advocate = AdvocateUser.authenticate(params[:email], params[:password])
    if advocate
      session[:advocate] = advocate.id
      redirect_to advocate_path
    else
      flash[:alert] = "Sisäänkirjautuminen epäonnistui."
      redirect_to new_advocate_session_path
    end
  end

  def destroy
    session[:advocate] = nil
    flash[:notice] = "Kirjauduit ulos."
    redirect_to new_advocate_session_path
  end
end
