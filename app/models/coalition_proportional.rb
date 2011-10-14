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

      coalition.candidates.by_alliance_proportional(result).each_with_index do |candidate, array_index|
        self.create_or_update! :result_id => result.id, :candidate_id => candidate.id,
                               :number => calculate_proportional(coalition_votes, array_index)
      end
    end

  def find_duplicate_numbers(result_id)
    select("#{table_name}.number").from(table_name).where(
    "#{table_name}.result_id = ?", result_id).group(
    "#{table_name}.number having count(*) > 1").order("#{table_name}.number desc")
  end

  end

end
