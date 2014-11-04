class VoterStatisticsPublisher

  def self.publish!
    Rails.logger.info "Publishing voters by voting area"
    store_s3_object("#{directory}/voters_by_voting_area.json", VoterStatistics.by_voting_area)

    Rails.logger.info "Publishing voters by gender"
    store_s3_object("#{directory}/voters_by_gender.json", VoterStatistics.by_gender)
  end

  def self.directory
    Vaalit::Results::DIRECTORY
  end

  def self.bucket_name
    Vaalit::Results::S3_BUCKET_NAME
  end

  # AWS connection is established only in production mode
  # N.B. This is copypasta from ResultPublisher
  def self.store_s3_object(filepath, contents)
    if Vaalit::AWS.connect?
      Rails.logger.info "Storing result contents to S3, bucket: '#{bucket_name}', filepath: '#{filepath}'"
      AWS::S3::S3Object.store(filepath, contents, bucket_name, :content_type => 'text/html; charset=utf-8')
    else
      message = "Not storing ('#{filepath}') to S3 because were are in development environment."

      Rails.logger.info message
      puts message
    end
  end

end
