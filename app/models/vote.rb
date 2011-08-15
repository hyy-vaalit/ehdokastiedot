class Vote < ActiveRecord::Base

  belongs_to :voting_area
  belongs_to :candidate

  validates_presence_of :voting_area, :candidate

  scope :ready, joins(:voting_area).where('voting_areas.taken = ?', true)

  default_scope :include => :candidate, :order => 'candidates.candidate_number'

  def self.calculated
    votes_ready = self.ready.count
    if votes_ready == self.count
      100
    else
      total_votes = Configuration.find_by_key 'total_vote_count'
      if total_votes
        (100 * votes_ready / total_votes.value.to_i).to_i
      else
        0
      end
    end
  end

end
