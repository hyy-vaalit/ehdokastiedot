class Result < ActiveRecord::Base
  has_many :coalition_proportionals, :dependent => :destroy
  has_many :alliance_proportionals, :dependent => :destroy

  has_many :candidates_in_election_order,
           :through => :coalition_proportionals,
           :select  => 'candidates.id,candidates.candidate_name, candidates.candidate_number,
                        coalition_proportionals.number as coalition_proportional, coalition_proportionals.number', # selected twice for count(*)
           :source  => :candidate,
           :order   => 'coalition_proportionals.number desc'

  has_many :candidate_results, :dependent => :destroy
  has_many :candidates,
           :through => :candidate_results,
           :select => "candidates.id, candidates.candidate_name, candidates.candidate_number,
                       candidates.electoral_alliance_id"

  has_many :alliance_results, :dependent => :destroy
  has_many :electoral_alliances,
           :through => :alliance_results

  has_many :coalition_results, :dependent => :destroy
  has_many :electoral_coalitions,
           :through => :coalition_results,
           :select => "electoral_coalitions.id, electoral_coalitions.name, electoral_coalitions.shorten"

  after_create :calculate_proportionals!

  def coalition_results_by_vote_sum
    coalition_results.order("vote_sum_cache desc")
  end

  def alliance_results_by_vote_sum
    alliance_results.order("vote_sum_cache desc")
  end

  def candidate_results_by_vote_sum
    candidate_results.order("vote_sum_cache desc")
  end

  def candidate_results_in_election_order
    candidates_in_election_order.select(
        'alliance_proportionals.number     AS  alliance_proportional,
         electoral_alliances.shorten       AS  electoral_alliance_shorten,
         candidate_results.elected         AS  elected,
         alliance_draws.identifier         AS  alliance_draw_identifier,
         candidate_results.vote_sum_cache  AS  vote_sum').joins(
        'INNER JOIN electoral_alliances    ON  candidates.electoral_alliance_id   = electoral_alliances.id').joins(
        'INNER JOIN candidate_results      ON  candidates.id = candidate_results.candidate_id').joins(
        'LEFT OUTER JOIN alliance_draws    ON  candidate_results.alliance_draw_id = alliance_draws.id').joins(
        'INNER JOIN alliance_proportionals ON  candidates.id = alliance_proportionals.candidate_id').where(
        ['alliance_proportionals.result_id = ?', self.id])
  end

  def alliance_results_of(coalition_result)
    alliance_results.for_alliances(coalition_result.electoral_coalition.electoral_alliance_ids)
    # TODO: order by ?
  end

  def candidate_results_of(alliance_result)
    candidate_results_in_election_order.where(
      'electoral_alliance_id = ? ', alliance_result.electoral_alliance_id).reorder(
      'vote_sum_cache desc')
  end

  protected

  def calculate_proportionals!
    Result.transaction do
      calculate_votes!
      alliance_proportionals!
      coalition_proportionals!
      elect_candidates!
      create_alliance_draws!
    end
  end

  def alliance_proportionals!
    AllianceProportional.calculate!(self)
  end

  def coalition_proportionals!
    CoalitionProportional.calculate!(self)
  end

  def calculate_votes!
    Candidate.by_vote_sum.each do |candidate|
      CandidateResult.create! :result => self, :vote_sum_cache => candidate.vote_sum, :candidate_id => candidate.id
    end
  end

  def elect_candidates!
    candidate_ids = candidate_results_in_election_order.limit(Vaalit::Voting::ELECTED_CANDIDATE_COUNT).map(&:id)
    CandidateResult.elect!(candidate_ids, self.id)
  end

  def create_alliance_draws!
    CandidateResult.find_duplicate_vote_sums(self.id).each_with_index do |draw, index|
      candidate_ids = ElectoralAlliance.find(draw.electoral_alliance_id).candidate_ids
      candidate_results = CandidateResult.find(:all, :conditions => ["candidate_id IN (?) AND vote_sum_cache = ?", candidate_ids, draw.vote_sum_cache])

      alliance_draw = AllianceDraw.create! :result_id => self.id, :identifier_number => index
      alliance_draw.candidate_results << candidate_results
    end
  end
end
