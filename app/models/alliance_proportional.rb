class AllianceProportional < ActiveRecord::Base
  include ProportionCalculations

  belongs_to :result
  belongs_to :candidate

  validates_presence_of :result_id, :candidate_id, :number

  # For each coalition C,
  # iterate through all its alliances
  # ordered by their total vote sum.
  #
  # For each alliance A of coalition C,
  # give the sum S of all A's votes
  # to the A's candidate with most votes.
  # Give S divided by 2 to the candidate with second most votes
  # and S divided by N to the candidate with Nth most votes.
  #
  # The number in question is the alliance proportional.
  def self.calculate!(result)
    ElectoralCoalition.all.each do |coalition|
      coalition.electoral_alliances.each do |alliance|
        alliance_votes = alliance.votes.preliminary_sum
        alliance.candidates.by_vote_sum.each_with_index do |candidate, array_index|
          self.create! :result_id => result.id, :candidate_id => candidate.id, :number => calculate_proportional(alliance_votes, array_index)
        end
      end
    end
  end

end
