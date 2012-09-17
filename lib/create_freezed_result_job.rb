class CreateFreezedResultJob

  def perform
    Rails.logger.info "Creating the Freezed Result (it will not be stored as a text)"
    Result.create_freezed!
  end

end