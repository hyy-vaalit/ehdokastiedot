class Email < ActiveRecord::Base

  validates_presence_of :subject, :content

  # Attributes searchable in ActiveAdmin
  def self.ransackable_attributes(_auth_object = nil)
    # allow all
    authorizable_ransackable_attributes
  end

  # Associations searchable in ActiveAdmin
  def self.ransackable_associations(_auth_object = nil)
    # allow all
    authorizable_ransackable_associations
  end

  # Enqueues a send-to-all-candidates job once. Returns false if the email
  # has already been sent.
  def enqueue!
    return false if enqueued_at?

    Delayed::Job::enqueue(EnqueueCandidateEmails.new(self))
    mark_enqueued!
  end


  private

  def mark_enqueued!
    update_attribute(:enqueued_at, Time.now)
  end
end
