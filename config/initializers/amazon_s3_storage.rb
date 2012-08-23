# See also:
#   config/initializers/000_vaalit.rb

if Rails.env.production?
  AWS::S3::Base.establish_connection!(
    :access_key_id     => ENV['S3_ACCESS_KEY_ID'],
    :secret_access_key => ENV['S3_ACCESS_KEY_SECRET']
  )
end
