require 'spec_helper'

describe ElectoralAlliance do
  it 'calculates the cached candidate vote sum' do
    votes = 10
    VotableSupport::stub_result_class!
    alliance = FactoryGirl.create(:electoral_alliance)
    result   = FactoryGirl.create(:result)
    candidate = FactoryGirl.create(:candidate, :electoral_alliance => alliance)
    FactoryGirl.create(:candidate_result, :vote_sum_cache => votes,
                                          :candidate => candidate, :result => result)
    FactoryGirl.create(:candidate_result, :vote_sum_cache => votes,
                                          :candidate => candidate, :result => result)

    alliance.vote_sum_caches.find_by_result_id(result.id).alliance_vote_sum_cache.to_i.should == 2 * votes
  end
end
