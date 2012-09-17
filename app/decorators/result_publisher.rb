# Flow:
#
# set status to pending
# create aws s3 job
# job calls actual publish method:
#   - uploads to s3
#   - sets published=true
#   - initializes mobile push notification

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
    result_content = ResultDecorator.new(self).rendered_output

    store_s3_object("#{directory}/#{better_filename}", result_content)
  end

  private

  def better_filename
    self.published? ? public_filename : unique_filename
  end

  def directory
    Vaalit::Results::DIRECTORY
  end

  def bucket_name
    Vaalit::Results::S3_BUCKET_NAME
  end

  def public_filename
    Vaalit::Results::PUBLIC_FILENAME
  end

  def unique_filename
    self.filename
  end

  # AWS connection is established only in production mode (see amazon_s3_storage.rb initializer)
  def store_s3_object(filepath, contents)
    Rails.logger.info "Storing result contents to S3, bucket: '#{bucket_name}', filepath: '#{filepath}'"
    AWS::S3::S3Object.store(filepath, contents, bucket_name, :content_type => 'text/plain; charset=utf-8')
  end

end