class CandidateResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :candidate
  belongs_to :candidate_draw, :dependent => :destroy
  belongs_to :coalition_draw, :dependent => :destroy

  has_one :alliance_proportional,
            -> { where('alliance_proportionals.result_id = result_id') },
            source: :alliance_proportionals,
            through: :candidate

  validates_presence_of :result_id, :candidate_id

  scope :by_candidate_draw_order, -> { order("candidate_draw_order asc") }
  scope :by_coalition_draw_order, -> { order("coalition_draw_order asc") }
  scope :by_vote_sum, -> {order("vote_sum_cache desc") }

  def self.most_voted(number = 10)
    by_vote_sum.limit(number)
  end

  def self.for_candidates(candidate_ids)
    where(["candidate_id IN (?)", candidate_ids])
  end


  def self.elect!(candidate_ids, result_id)
    #  UPDATE "candidate_results" SET elected = 'f' WHERE (result_id = 1)
    where(
      "result_id = ?", result_id
    ).update_all( ["elected = ?", false] )

    # UPDATE "candidate_results" SET elected = 't' WHERE (result_id = 1 AND candidate_id IN (1,2))
    where(
      "result_id = ? AND candidate_id IN (?)", result_id, candidate_ids
    ).update_all( ["elected = ?", true] )
  end

  def self.find_duplicate_vote_sums(result_id)
    select('candidates.electoral_alliance_id, candidate_results.vote_sum_cache').from('candidate_results').joins(
      'inner join candidates on candidate_results.candidate_id = candidates.id').where(
      'candidate_results.result_id = ?', result_id).group(
      'candidates.electoral_alliance_id, candidate_results.vote_sum_cache having count(*) > 1').order('electoral_alliance_id')
  end

  def self.elected
    where(:elected => true)
  end

  def self.elected_in_alliance(alliance_id, result_id)
    elected.joins(
    'INNER JOIN candidates            ON candidate_results.candidate_id     = candidates.id').joins(
    'INNER JOIN electoral_alliances   ON electoral_alliances.id             = candidates.electoral_alliance_id').where(
    'electoral_alliances.id = ? AND candidate_results.result_id = ?', alliance_id, result_id)
  end

  def self.elected_in_coalition(coalition_id, result_id)
    elected.joins(
    'INNER JOIN candidates            ON candidate_results.candidate_id     = candidates.id').joins(
    'INNER JOIN electoral_alliances   ON electoral_alliances.id             = candidates.electoral_alliance_id').where(
    'electoral_alliances.electoral_coalition_id = ? AND candidate_results.result_id = ?', coalition_id, result_id)
  end

end
