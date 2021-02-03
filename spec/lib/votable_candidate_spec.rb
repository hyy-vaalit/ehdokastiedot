require 'spec_helper'

describe 'votable behaviour' do

  before(:each) do
    stub_result_class!
    @ready_voting_areas = []
    @unready_voting_areas = []
    3.times { @ready_voting_areas << FactoryBot.create(:ready_voting_area) }
    3.times { @unready_voting_areas << FactoryBot.create(:unready_voting_area) }
  end

  def stub_result_class!
    allow(Result).to receive(:calculate_votes!)
    allow(Result).to receive(:alliance_proportionals!)
    allow(Result).to receive(:coalition_proportionals!)
  end

  describe 'votable candidates' do
    it 'allows chaining with_votes_sum with other scopes' do
      alliance = FactoryBot.create(:electoral_alliance_with_candidates)
      other_alliance = FactoryBot.create(:electoral_alliance_with_candidates)
      VotableSupport::create_votes_for(alliance.candidates, @ready_voting_areas, :ascending => true)
      VotableSupport::create_votes_for(other_alliance.candidates, @ready_voting_areas, :ascending => true)

      expect(Candidate.count).to be > alliance.candidates.count
      expect(alliance.candidates.with_vote_sums.map(&:id)).to eq alliance.candidates.reverse.map(&:id)
    end

    it 'allows chaining with_alliance_proportionals_for with other scopes' do
      result = FactoryBot.create(:result_with_alliance_proportionals_and_candidates)
      alliance = result.alliance_proportionals.first.candidate.electoral_alliance
      expect(Candidate.count).to be > alliance.candidates.count

      # FIXME: flaky test when not running all tests at once (running tests on this file only)
      expect(alliance.candidates.with_alliance_proportionals_for(result).map(&:id)).to eq alliance.candidates.map(&:id)
    end

    describe 'preliminary votes' do

      before(:each) do
        @candidate = FactoryBot.create(:candidate)
      end

      it 'has preliminary votes from voting areas which have been fully counted' do
        amount = 10
        @ready_voting_areas.each { |area| FactoryBot.create(:vote, :candidate => @candidate,
                                                                    :voting_area => area,
                                                                    :amount => amount) }

        expect(@candidate.votes.preliminary_sum).to eq(amount * @ready_voting_areas.count)
      end

      it 'does not add votes from unfinished voting areas to preliminary votes' do
        amount = 10
        [@ready_voting_areas, @unready_voting_areas].each do |area_group|
          area_group.each { |area| FactoryBot.create(:vote, :candidate => @candidate,
                                                             :voting_area => area,
                                                             :amount => amount) }
        end

        expect(@candidate.votes.preliminary_sum).to eq(amount * @ready_voting_areas.count)
      end

    end
  end

  describe 'votable alliance behaviour' do
    describe 'preliminary votes' do
      before(:each) do
        @alliance = FactoryBot.create(:electoral_alliance_with_candidates)
      end

      it 'has preliminary votes from voting areas which have been fully counted' do
        amount = 10
        @alliance.candidates.each { |c| VotableSupport::create_votes_for_candidate(c, amount, @ready_voting_areas) }

        expect(@alliance.votes.preliminary_sum).to eq(amount * @ready_voting_areas.count * @alliance.candidates.count)
      end

      it 'does not count votes from unfinished voting areas to preliminary votes' do
        amount = 10
        @alliance.candidates.each do |candidate|
          VotableSupport::create_votes_for_candidate(candidate, amount, @ready_voting_areas)
          VotableSupport::create_votes_for_candidate(candidate, amount, @unready_voting_areas)
        end

        expect(@alliance.votes.preliminary_sum).to eq(amount * @ready_voting_areas.count * @alliance.candidates.count)
      end
    end

  end

  describe 'votable coalition behaviour' do
    describe 'preliminary votes' do
      before(:each) do
        @coalition = FactoryBot.create(:electoral_coalition_with_alliances_and_candidates)
      end

      it 'has preliminary votes as a sum of alliance votes' do
        amount = 10
        @coalition.electoral_alliances.each { |alliance| VotableSupport::create_votes_for_alliance(alliance, amount, @ready_voting_areas) }

        expect(@coalition.preliminary_vote_sum).to eq(amount * @ready_voting_areas.count * @coalition.candidates.count)
      end

      it 'does not count votes from unfinished voting areas to preliminary votes' do
        amount = 10
        @coalition.electoral_alliances.each do |alliance|
          VotableSupport::create_votes_for_alliance(alliance, amount, @ready_voting_areas)
          VotableSupport::create_votes_for_alliance(alliance, amount, @unready_voting_areas)
        end

        expect(@coalition.preliminary_vote_sum).to eq(amount * @ready_voting_areas.count * @coalition.candidates.count)
      end
    end

  end

end
