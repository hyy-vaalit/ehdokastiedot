class CandidateResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :candidate
  belongs_to :alliance_draw, :dependent => :destroy
  belongs_to :coalition_draw, :dependent => :destroy

  validates_presence_of :result_id, :candidate_id

  def self.for_candidates(candidate_ids)
    find(:all, :conditions => ["candidate_id IN (?)", candidate_ids])
  end

  def self.elect!(candidate_ids, result_id)
    update_all ["elected = ?", true], ["result_id = ? AND candidate_id IN (?)", result_id, candidate_ids]
  end

  def self.find_duplicate_vote_sums(result_id)
    select('candidates.electoral_alliance_id, candidate_results.vote_sum_cache').from('candidate_results').joins(
      'inner join candidates on candidate_results.candidate_id = candidates.id').where(
      'candidate_results.result_id = ?', result_id).group(
      'candidates.electoral_alliance_id, candidate_results.vote_sum_cache having count(*) > 1').order('electoral_alliance_id')
  end

end
