class RegistrationsController < ApplicationController
  skip_authorization_check only: :index

  def index
    @candidate = Candidate.valid.find_by(student_number: current_haka_user.student_number)
  end
end
