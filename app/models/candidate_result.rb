class CandidateResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :candidate

  def self.for_candidates(candidate_ids)
    find(:all, :conditions => ["candidate_id IN (?)", candidate_ids])
  end

  def self.elect!(candidate_ids, result_id)
    update_all ["elected = ?", true], ["result_id = ? AND candidate_id IN (?)", result_id, candidate_ids]
  end
end
