class CandidateNotifier < HyyMailer

  def welcome_as_candidate(addresses, email)
    @email = email
    sendgrid_category = "Ehdokasilmoitus"
    sendgrid_recipients addresses
    mail(:subject => @email.subject)
  end

end
