class CandidateNotifier < HyyMailer

  def welcome_as_candidate(recipient_address, email)
    @email = email
    sendgrid_category = "Ehdokasilmoitus"

    mail :to => recipient_address, :subject => "Ehdokasilmoittautumisesi on vastaanotettu"
  end

end
