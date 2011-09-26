class CoalitionProportional < ActiveRecord::Base
  belongs_to :result
  belongs_to :candidate

    # ota liiton kaikki ehdokkaat
    # järjestettynä liittovertailuluvun mukaan
    # jokaiselle ehdokkaalle e,
    # anna koko liiton saamat äänet jaettuna iteraatiokierroken järjestysnumerolla. /1, /2,..,/n
  def self.calculate!
    ElectoralCoalition.all.each do |coalition|
      coalition_votes = coalition.preliminary_vote_sum
      coalition.candidates.by_vote_sum.each_with_index do |candidate, array_index|
        raise "TÄHÄN JÄIN lololo"
        self.create! :candidate_id => candidate.id, :number => calculate_proportional(coalition_votes, array_index)
      end
    end

  end

  private

  def self.calculate_proportional(votes, array_index)
    votes / (array_index + 1)
  end
end
