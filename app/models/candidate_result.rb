class CandidateResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :candidate

  def self.for_candidates(candidate_ids)
    find(:all, :conditions => ["candidate_id IN (?)", candidate_ids])
  end

end
