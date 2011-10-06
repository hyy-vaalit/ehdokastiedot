require 'spec_helper'

describe CandidateResult do
  it 'finds duplicate vote sums in the same alliance' do
    VotableSupport::stub_result_class!
    draw_candidates = []
    nodraw_candidates = []
    alliance = FactoryGirl.create(:electoral_alliance_with_candidates)
    result   = FactoryGirl.create(:result)

    alliance.candidates.each_with_index do |candidate, index|
      if index % 2 == 0
        FactoryGirl.create(:candidate_result, :vote_sum_cache => 100, :result => result, :candidate => candidate)
      else
        FactoryGirl.create(:candidate_result, :vote_sum_cache => index, :result => result, :candidate => candidate)
      end
    end

    draws = CandidateResult.find_duplicate_vote_sums(result)
    draws.first.vote_sum_cache.should == 100
    draws.first.should == draws.last # size == 1 hack since count/size will create pgsql syntax error
  end
end
