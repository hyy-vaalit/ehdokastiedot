require 'spec_helper'

describe CandidateResult do

  before(:each) do
    stub_result_class!
  end

  def stub_result_class!
    allow(Result).to receive(:calculate_votes!)
    allow(Result).to receive(:alliance_proportionals!)
    allow(Result).to receive(:coalition_proportionals!)
  end

  it 'finds duplicate vote sums in the same alliance' do
    draw_candidates = []
    nodraw_candidates = []
    alliance = FactoryBot.create(:electoral_alliance_with_candidates)

    #TODO: Fix result factory so that it doesn't create CandidateResults
    result = FactoryBot.create(:result)
    CandidateResult.destroy_all

    draw_votes = 100

    VotableSupport::create_candidate_draws(alliance, result, draw_votes)

    draws = CandidateResult.find_duplicate_vote_sums(result)
    expect(draws.first.vote_sum_cache).to eq draw_votes
    expect(draws.length).to eq 1
  end
end
