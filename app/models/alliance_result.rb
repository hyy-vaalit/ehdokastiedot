class AllianceResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :electoral_alliance

  scope :by_vote_sum, -> { order("vote_sum_cache desc") }

  def self.for_alliances(alliance_ids)
    where(["electoral_alliance_id IN (?)", alliance_ids])
  end

  # Params:
  #  :result => result,
  #  :electoral_alliance => alliance,
  #  :vote_sum_cache => alliance_votes
  def self.create_or_update!(opts = {})
    if existing = self.where(:electoral_alliance_id => opts[:electoral_alliance]).where(:result_id => opts[:result]).first
      existing.update_attributes!(:vote_sum_cache => opts[:vote_sum_cache])
    else
      self.create!(opts)
    end
  end
end
