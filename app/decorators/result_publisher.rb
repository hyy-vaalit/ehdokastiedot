# Flow:
#
# set status to pending
# create aws s3 job
# job calls actual publish method:
#   - uploads Result#to_html to s3
#   - uploads Result#to_json to s3
#   - sets published=true if result is made "public" (ie. index.html or index.json), otherwise uses unique filename
class ResultPublisher < ApplicationDecorator
  decorates :result

  def self.create_and_store!
    Result.transaction do
      result = Result.create!
      self.find(result).store_to_s3!
    end
  end

  def self.finalize_and_store!
    Result.transaction do
      result = Result.freezed.first
      result.finalize!

      self.find(result).store_to_s3!
    end
  end

  def publish!
    Result.transaction do
      self.published_pending!
      Delayed::Job::enqueue(PublishResultJob.new(self.id))
    end
  end

  def store_and_make_public!
    Result.transaction do
      self.published!
      store_to_s3!
    end
  end

  def store_to_s3!
    Rails.logger.info "Rendering result output"
    result = ResultDecorator.new(self)

    store_s3_object("#{directory}/#{better_filename('.html')}", result.to_html)
    store_s3_object("#{directory}/#{better_filename('.json')}", result.to_json)
    store_s3_object("#{directory}/#{better_filename('.json', 'candidates')}", result.to_json_candidates)
  end

  private

  def better_filename(suffix, name = "tulos")
    self.published? ? public_filename(suffix, name) : unique_filename(suffix, name)
  end

  def directory
    Vaalit::Results::DIRECTORY
  end

  def bucket_name
    Vaalit::Results::S3_BUCKET_NAME
  end

  def public_filename(suffix, name)
    "#{name}#{suffix}"
  end

  def unique_filename(suffix, name)
    self.filename(suffix, name)
  end

  # AWS connection is established only in production mode
  def store_s3_object(filepath, contents)
    if Vaalit::AWS.connect?
      Rails.logger.info "Storing result contents to S3, bucket: '#{bucket_name}', filepath: '#{filepath}'"
      AWS::S3::S3Object.store(filepath, contents, bucket_name, :content_type => 'text/html; charset=utf-8')
    else
      Rails.logger.info "Not storing result ('#{filepath}') to S3 because were are in development environment."
    end
  end

end
