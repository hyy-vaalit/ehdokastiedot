Aws::Rails.add_action_mailer_delivery_method(
  :aws_sdk,
  credentials: Aws::Credentials.new(
    Vaalit::Aws::Ses::ACCESS_KEY_ID,
    Vaalit::Aws::Ses::SECRET_ACCESS_KEY,
  ),
  region: Vaalit::Aws::Ses::REGION
)
