class ElectoralAlliance < ActiveRecord::Base
  include RankedModel

  has_many :candidates

  belongs_to :electoral_coalition
  ranks :signing_order, :with_same => :electoral_coalition_id

  def freeze!
    self.update_attribute :secretarial_freeze, true
  end

  def total_votes
    self.candidates.map(&:total_votes).sum
  end

end
