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
    au = AdvocateUser.find_or_create_by_ssn(self.primary_advocate_social_security_number)
    au.email = self.primary_advocate_email
    au.save
  end

end
