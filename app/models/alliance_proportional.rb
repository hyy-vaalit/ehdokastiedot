class AllianceProportional < ActiveRecord::Base
  include ProportionCalculations

  belongs_to :result
  belongs_to :candidate

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
