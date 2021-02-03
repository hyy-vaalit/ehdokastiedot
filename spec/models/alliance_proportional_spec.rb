require 'spec_helper'

describe AllianceProportional do

  it 'gives /n of the votes of an alliance to the candidate with nth most votes as an alliance proportional' do
    allow(CoalitionProportional).to receive(:calculate!)
    coalition = FactoryBot.create(:electoral_coalition_with_alliances_and_candidates)
    alliance = coalition.electoral_alliances.first
    total_vote_sum = 1235

    allow(ElectoralCoalition).to receive(:all).and_return([coalition])
    allow(coalition).to receive(:electoral_alliances).and_return([alliance])
    allow(alliance.candidates).to receive(:with_vote_sums_for).and_return(alliance.candidates)
    allow(alliance.votes).to receive(:countable_sum).and_return(total_vote_sum)

    FactoryBot.create(:result)

    # Reversed array order: Last candidate has the biggest proportional number
    alliance.candidates.reverse.each_with_index do |candidate, index|
      expect(candidate.alliance_proportionals.last.number)
        .to eq(
          (total_vote_sum.to_f / (alliance.candidates.count - index)).round(Vaalit::Voting::PROPORTIONAL_PRECISION)
        )
    end

  end

end
