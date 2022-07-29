class RegistrationsController < ApplicationController
  skip_authorization_check only: :index

  before_action :require_haka_user

  def index
    @candidate = Candidate.valid.find_by(student_number: current_haka_user.student_number)
  end

  protected

  def require_haka_user
    if current_haka_user.nil?
      flash.now.alert = "Kirjaudu ensin sisään."
      render "common/unauthorized", status: 401 and return
    end
  end
end
