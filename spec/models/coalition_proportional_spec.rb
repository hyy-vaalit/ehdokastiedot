require 'spec_helper'

describe CoalitionProportional do


  it 'gives all the votes of a coalition to the candidate with most votes as a coalition proportional' do
    coalitions = [
      FactoryGirl.build(:electoral_coalition_with_alliances),
      FactoryGirl.build(:electoral_coalition_with_alliances),
      FactoryGirl.build(:electoral_coalition_with_alliances)
    ]

    ElectoralCoalition.should_receive(:all).and_return(coalitions)
    coalitions[0].should_receive(:preliminary_vote_sum).at_least(:once).and_return(100)
    coalitions[1].should_receive(:preliminary_vote_sum).at_least(:once).and_return(200)
    coalitions[2].should_receive(:preliminary_vote_sum).at_least(:once).and_return(300)

    CoalitionProportional.calculate!

  end

#    result.coalition_proportionals ### XYZ

end
