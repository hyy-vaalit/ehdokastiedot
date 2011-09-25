require 'spec_helper'

describe AllianceProportional do
  it 'gives all votes of an alliance to the candidate with most votes' do
    alliance = FactoryGirl(:create_alliance_with_candidates)
    alliance.candidates.each { |c| c.votes.should_receive(:preliminary_sum).and_return(100)}

    AllianceProportional.calculate!

    raise
  end

  it 'gives /2 of the alliance votes to the candidate with second most votes'
  it 'gives /n of the alliance votes to the candidate with second most votes'

end
