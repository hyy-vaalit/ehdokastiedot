class CandidateNotifier < HyyMailer

  def welcome_as_candidate(addresses, email)
    @email = email
    mail(:bcc => addresses.join(','), :subject => @email.subject)
  end

end
