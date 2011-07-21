class CandidateNotifier < ActionMailer::Base
  default :from => "hostmaster-hyy@enemy.fi"

  def welcome_as_candidate(candidate)
    @candidate = candidate
    mail(:to => @candidate.email, :subject => t('mailer.candidate_notifier.welcome_as_candidate.subject'))
  end
end
