class ListingsController < ApplicationController

  skip_authorization_check

  def same_ssn
  end

  def simple
    @candidates = Candidate.all
  end

end
