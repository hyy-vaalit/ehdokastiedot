class ElectoralAlliance < ActiveRecord::Base
  include RankedModel

  has_many :candidates
  belongs_to :advocate_user, :foreign_key => :primary_advocate_social_security_number, :primary_key => :ssn

  belongs_to :electoral_coalition
  ranks :signing_order, :with_same => :electoral_coalition_id

  scope :without_coalition, where(:electoral_coalition_id => nil)

  def freeze!
    self.update_attribute :secretarial_freeze, true
  end

  def total_votes
    self.candidates.map(&:total_votes).sum
  end

  after_create do
    return unless self.primary_advocate_social_security_number # Seed, etc
    unless AdvocateUser.find_by_ssn(self.primary_advocate_social_security_number)
      AdvocateUser.create! :ssn => self.primary_advocate_social_security_number, :email => self.primary_advocate_email
    end
  end

end
