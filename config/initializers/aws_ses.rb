ActionMailer::Base.add_delivery_method(
  :aws_ses,
  Aws::ActionMailer::SESV2::Mailer,
  region: ENV.fetch('AWS_REGION', 'eu-west-1'),
  credentials: Aws::Credentials.new(
    ENV.fetch('AWS_ACCESS_KEY_ID'),
    ENV.fetch('AWS_SECRET_ACCESS_KEY')
  )
)
