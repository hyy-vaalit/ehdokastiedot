class AllianceDrawsReadyJob

  def perform
    puts "Marking alliance draws ready and calculating new coalition draws!"
    Result.freezed.first.alliance_draws_ready!
  end
end