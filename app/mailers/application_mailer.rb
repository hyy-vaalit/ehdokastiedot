class ApplicationMailer < ActionMailer::Base
  default :from => GlobalConfiguration.mail_from_address
  layout 'mailer'
end
