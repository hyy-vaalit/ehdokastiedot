class CoalitionDrawsReadyJob

  def perform
    puts "Finalizing the result!"
    Result.freezed.first.finalize!
  end
end