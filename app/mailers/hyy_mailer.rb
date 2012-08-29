class HyyMailer < ActionMailer::Base
  include SendGrid
  default :from => GlobalConfiguration.mail_from_address if Rails.env.production?

end
