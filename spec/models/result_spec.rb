require 'spec_helper'

describe Result do

  it 'should initiate coalition proportional calculations' do
    CoalitionProportional.should_receive(:calculate!)

    Result.create!
  end

  it 'should initiate alliance proportional calculations' do
    AllianceProportional.should_receive(:calculate!)

    Result.create!
  end

  it 'creates alliance draws for duplicate vote sums in a same alliance'
  # do
  #   Result.stub!(:calculate_votes!)
  #   Result.stub!(:alliance_proportionals!)
  #   Result.stub!(:coalition_proportionals!)
  #   Result.stub!(:elect_candidates!)
  #   Result.should_receive(:create_candidate_draws!)
  #   alliance   = FactoryGirl.create(:electoral_alliance_with_candidates)
  #   result     = FactoryGirl.create(:result)
  #   draw_votes = 100
  #
  #   CandidateResult.should_receive(:find_duplicate_vote_sums).and_return(Factory(:draw_candidate_result))
  #
  #   VotableSupport::create_candidate_draws(alliance, result, draw_votes)
  #
  #
  # end

  it 'marks candidates elected'


end
