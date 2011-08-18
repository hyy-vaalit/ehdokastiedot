class Vote < ActiveRecord::Base

  belongs_to :voting_area
  belongs_to :candidate

  validates_presence_of :voting_area, :candidate

  scope :ready, joins(:voting_area).where('voting_areas.taken = ?', true)

  default_scope :include => :candidate, :order => 'candidates.candidate_number'

  def self.calculated
    votes_ready = self.ready.sum(:vote_count)
    if votes_ready == self.sum(:vote_count)
      100
    else
      total_votes = REDIS.get('total_vote_count')
      if total_votes
        (100 * votes_ready / total_votes.to_i).to_i
      else
        0
      end
    end
  end

end
