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

  # AWS connection is established only in production mode
  # N.B. This is copypasta from ResultPublisher
  def self.store_s3_object(filepath, contents)
    if Vaalit::Aws.connect?
      raise "S3 removed"
    else
      message = "Not storing ('#{filepath}') to S3 because were are in development environment."

      Rails.logger.info message
      puts message
    end
  end
end
