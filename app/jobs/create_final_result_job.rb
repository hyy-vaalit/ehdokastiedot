class CreateFinalResultJob

  def perform
    Rails.logger.info "Creating the Final Result!"
    ResultPublisher.finalize_and_store!
  end

end

