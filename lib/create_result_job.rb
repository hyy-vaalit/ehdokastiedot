class CreateResultJob

  def perform
    puts "Creating new Result!"
    result = Result.create!

    # hackety hack, #todo: extract class
    if Rails.env.production?
      s3_bucket_name = ENV['S3_BUCKET_NAME']
      public_filename = Vaalit::Results::PUBLIC_FILENAME
      unique_filename = result.filename
      puts "Rendering result output"
      result_output = ResultDecorator.new(result).rendered_output

      puts "Storing new preliminary result to S3"
      AWS::S3::S3Object.store(public_filename, result_output, s3_bucket_name, :content_type => 'text/plain; charset=utf-8' )
      AWS::S3::S3Object.store(unique_filename, result_output, s3_bucket_name, :content_type => 'text/plain; charset=utf-8' )
    end
  end

end