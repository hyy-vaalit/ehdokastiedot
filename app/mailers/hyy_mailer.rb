class HyyMailer < ActionMailer::Base
  include SendGrid
  default :from => REDIS.get('mailaddress')

end
