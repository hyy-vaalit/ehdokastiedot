class CoalitionProportional < ActiveRecord::Base
  include ProportionCalculations

  belongs_to :result
  belongs_to :candidate

  validates_presence_of :result_id, :candidate_id, :number

  # Iterate through all candidates of a coalition
  # ordered by their alliance proportional number.
  #
  # Give the sum S of all coalition's votes
  # to the candidate with the highest alliance proportional number.
  # Give S divided by 2 to the candidate with second most votes
  # and S divided by N to the candidate with Nth most votes.,
  #
  # The number in question is the coalition proportional number.
  def self.calculate!(result)
    ElectoralCoalition.all.each do |coalition|
      coalition_votes = coalition.countable_vote_sum
      CoalitionResult.create_or_update! :result => result, :electoral_coalition => coalition, :vote_sum_cache => coalition_votes

      coalition.candidates.with_alliance_proportionals_for(result).each_with_index do |candidate, array_index|
        self.create_or_update! :result_id => result.id, :candidate_id => candidate.id,
                               :number => calculate_proportional(coalition_votes, array_index)
      end
    end
  end

  def self.find_duplicate_numbers(result_id)
    select("coalition_proportionals.number").from(table_name).where(
    "coalition_proportionals.result_id = ?", result_id).group(
    "coalition_proportionals.number having count(*) > 1").order("coalition_proportionals.number desc")
  end

  def self.find_draw_candidate_ids_of(draw_proportional, result_id)
    select('candidate_id').where(
        ["number = ? AND result_id = ?", draw_proportional.number, result_id]
    ).map(&:candidate_id)
  end

end
