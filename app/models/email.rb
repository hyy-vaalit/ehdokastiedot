class Email < ActiveRecord::Base

  validates_presence_of :subject, :content

  def enqueue!
    Delayed::Job::enqueue(EnqueueCandidateEmails.new(self))
    mark_enqueued!
  end


  private

  def mark_enqueued!
    update_attribute(:enqueued_at, Time.now)
  end
end
