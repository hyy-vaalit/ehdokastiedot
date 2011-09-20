class CandidateNotifier < HyyMailer

  def welcome_as_candidate(addresses, email)
    @email = email
    sendgrid_category = "Ehdokasilmoitus"
    sendgrid_recipients addresses
    subject @email.subject
    # Appears as an empty recipient list in development environment
  end

end
