# Flow:
#
# set status to pending
# create aws s3 job
# job calls actual publish method:
#   - uploads Result#to_html to s3
#   - uploads Result#to_json to s3
#   - sets published=true if result is made "public" (ie. index.html or index.json), otherwise uses unique filename
class ResultPublisher

  def initialize(result)
    @result = result
  end

  def self.create_and_store!
    Result.transaction do
      instance = self.new(Result.create!)

      instance.store_to_s3!
    end
  end

  def self.finalize_and_store!
    Result.transaction do
      result = Result.freezed.first
      result.finalize!

      instance = self.new(result)
      instance.store_to_s3!
    end
  end

  def publish!
    Result.transaction do
      @result.published_pending!
      Delayed::Job::enqueue(PublishResultJob.new(@result.id))
    end
  end

  def store_and_make_public!
    Result.transaction do
      @result.published!
      store_to_s3!
    end
  end

  def store_to_s3!
    Rails.logger.info "Rendering result output"
    decorated_result = ResultDecorator.decorate(@result)

    store_s3_object("#{directory}/#{better_filename('.html')}", decorated_result.to_html)
    store_s3_object("#{directory}/#{better_filename('.json')}", decorated_result.to_json)
    store_s3_object("#{directory}/#{better_filename('.json', 'candidates')}", decorated_result.to_json_candidates)
  end

  private

  def better_filename(suffix, name = "result")
    @result.published? ? public_filename(suffix, name) : unique_filename(suffix, name)
  end

  def directory
    Vaalit::Results::DIRECTORY
  end

  def public_filename(suffix, name)
    "#{name}#{suffix}"
  end

  def unique_filename(suffix, name)
    @result.filename(suffix, name)
  end

  # AWS connection is established only in production mode
  def store_s3_object(filepath, contents)
    if Vaalit::Aws.connect?
      raise "S3 removed"
    else
      Rails.logger.info "Not storing result ('#{filepath}') to S3 because were are in development environment."
    end
  end

end
