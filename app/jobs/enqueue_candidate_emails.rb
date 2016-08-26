class EnqueueCandidateEmails

  attr_accessor :email_message

  def initialize(email_message)
    self.email_message = email_message
  end

  def perform
    puts "Sending email to all Candidates"

    Candidate.valid.each do |c|
      puts "Enqueuing email with id #{email_message.id} to #{c.email}"
      CandidateNotifier.delay.welcome_as_candidate(c.email, email_message)
    end
  end

end