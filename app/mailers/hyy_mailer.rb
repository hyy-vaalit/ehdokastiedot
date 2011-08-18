class HyyMailer < ActionMailer::Base

  default :from => REDIS.get('mailaddress')

end
