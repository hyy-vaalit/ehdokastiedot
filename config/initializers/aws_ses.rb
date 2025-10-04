Aws::Rails.add_action_mailer_delivery_method(
  :aws_ses,
  credentials: Aws::Credentials.new(
    ENV.fetch('AWS_ACCESS_KEY_ID'),
    ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  ),
  region: ENV.fetch('AWS_REGION', 'eu-west-1')
)
