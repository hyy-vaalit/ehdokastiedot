require 'spec_helper'

describe CoalitionProportional do


  it 'gives all the votes of a coalition to the candidate with most votes as a coalition proportional' do
    AllianceProportional.stub!(:calculate!)
    coalition =  FactoryGirl.create(:electoral_coalition_with_alliances_and_candidates)
    total_vote_sum = 1235

    ElectoralCoalition.should_receive(:all).and_return([coalition])
    coalition.candidates.should_receive(:by_vote_sum).and_return(coalition.candidates)
    coalition.should_receive(:preliminary_vote_sum).and_return(total_vote_sum)

    result = FactoryGirl.create(:result)

    coalition.candidates.reverse.each_with_index do |candidate, index|
      candidate.coalition_proportionals.last.number.should == (total_vote_sum.to_f / (coalition.candidates.count - index)).round(Vaalit::Voting::PROPORTIONAL_PRECISION)
    end

  end

end
