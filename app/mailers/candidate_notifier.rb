class CandidateNotifier < ActionMailer::Base
  default :from => "hostmaster-hyy@enemy.fi"

  def welcome_as_candidate(addresses, email)
    @email = email
    mail(:bcc => addresses, :subject => @email.subject)
  end
end
