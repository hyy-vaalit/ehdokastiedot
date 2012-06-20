class Advocates::CandidatesController < AdvocatesController

  def new
    @candidate = Candidate.new
  end
end
