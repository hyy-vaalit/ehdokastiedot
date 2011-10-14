require 'spec_helper'

describe CandidateResult do
  it 'finds duplicate vote sums in the same alliance' do
    VotableSupport::stub_result_class!
    draw_candidates = []
    nodraw_candidates = []
    alliance = FactoryGirl.create(:electoral_alliance_with_candidates)
    result   = FactoryGirl.create(:result)
    draw_votes = 100

    VotableSupport::create_candidate_draws(alliance, result, draw_votes)

    draws = CandidateResult.find_duplicate_vote_sums(result)
    draws.first.vote_sum_cache.should == draw_votes
    draws.first.should == draws.last # size == 1 hack since count/size will create pgsql syntax error
  end
end
