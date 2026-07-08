module AuthHelpers
  # Signs in as a Haka user via the fake authentication endpoint
  # (enabled in .env.test with STAGE=development, FAKE_AUTH_ENABLED=yes).
  def sign_in_haka(student_number)
    post haka_auth_fake_authentication_path,
      params: { fake_authentication: { student_number: student_number } }
  end
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods

  # `sign_in admin_user` for Devise AdminUser sessions
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include AuthHelpers, type: :request
end
