class CoalitionProportional < ActiveRecord::Base
  include ProportionCalculations

  belongs_to :result
  belongs_to :candidate

    # ota liiton kaikki ehdokkaat
    # järjestettynä liittovertailuluvun mukaan
    # jokaiselle ehdokkaalle e,
    # anna koko liiton saamat äänet jaettuna iteraatiokierroken järjestysnumerolla. /1, /2,..,/n
  def self.calculate!(result)
    ElectoralCoalition.all.each do |coalition|
      coalition_votes = coalition.preliminary_vote_sum
      coalition.candidates.by_vote_sum.each_with_index do |candidate, array_index|
        cp = self.create! :result_id => result.id, :candidate_id => candidate.id, :number => calculate_proportional(coalition_votes, array_index)
      end
    end

  end


end
