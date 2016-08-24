class CreateFreezedResultJob

  def perform
    Rails.logger.info "Creating the Freezed Result (it will not be stored in S3)"
    Result.create_freezed!
  end

end
