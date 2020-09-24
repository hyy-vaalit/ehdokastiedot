class CandidateNotifier < AwsMailer

  def welcome_as_candidate(recipient_address, email)
    @email = email

    mail :to => recipient_address, :subject => email.subject
  end

end
