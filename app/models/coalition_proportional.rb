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
      coalition_votes = coalition.preliminary_vote_sum
      coalition.candidates.by_alliance_proportional(result).each_with_index do |candidate, array_index|
        self.create! :result_id => result.id, :candidate_id => candidate.id, :number => calculate_proportional(coalition_votes, array_index)
      end
    end

  end


end
