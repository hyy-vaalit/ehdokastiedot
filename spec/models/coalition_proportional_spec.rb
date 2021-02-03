require 'spec_helper'

describe CoalitionProportional do

  it 'gives /n of the votes of a coalition to the candidate with nth most votes as a coalition proportional' do
    allow(AllianceProportional).to receive(:calculate!)
    coalition =  FactoryGirl.create(:electoral_coalition_with_alliances_and_candidates)
    total_vote_sum = 1235

    allow(ElectoralCoalition).to receive(:all).and_return([coalition])
    allow(coalition.candidates).to receive(:with_alliance_proportionals_for).and_return(coalition.candidates)
    allow(coalition).to receive(:countable_vote_sum).and_return(total_vote_sum)

    FactoryGirl.create(:result)

    # Reversed array order: Last candidate has the biggest proportional number
    coalition.candidates.reverse.each_with_index do |candidate, index|
      expect(candidate.coalition_proportionals.last.number)
        .to eq(
          (total_vote_sum.to_f / (coalition.candidates.count - index)).round(Vaalit::Voting::PROPORTIONAL_PRECISION)
        )
    end

  end

end
