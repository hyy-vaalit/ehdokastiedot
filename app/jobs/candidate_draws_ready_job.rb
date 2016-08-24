class CandidateDrawsReadyJob
  
  def perform
    puts "Marking candidate draws ready and calculating new alliance draws!"
    Result.freezed.first.candidate_draws_ready!
  end
end