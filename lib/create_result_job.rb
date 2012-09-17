class CreateResultJob

  def perform
    Rails.logger.info "Creating a new Result!"
    ResultPublisher.create_and_store!
  end

end