class EnqueueCandidateEmails

  attr_accessor :email_message

  def initialize(email_message)
    self.email_message = email_message
  end

  def perform
    Rails.logger.info "Sending email to all Candidates"

    Candidate.valid.each do |c|
      Rails.logger.info "Enqueuing email with id #{email_message.id} to #{c.email}"
      CandidateNotifier.delay.welcome_as_candidate(c.email, email_message)
    end
  end

end