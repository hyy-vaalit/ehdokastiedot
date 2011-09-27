require 'spec_helper'

describe 'votable behaviour' do
  before(:each) do
    @ready_voting_areas = []
    @unready_voting_areas = []
    3.times { @ready_voting_areas << FactoryGirl.create(:ready_voting_area) }
    3.times { @unready_voting_areas << FactoryGirl.create(:unready_voting_area) }
  end

  describe 'votable candidates' do

    it 'gives a list of all candidates ordered by their alliance proportional' do
      AllianceProportional.stub!(:calculate!)
      CoalitionProportional.stub!(:calculate!)
      result = FactoryGirl.create(:result_with_alliance_proportionals_and_candidates)

      ordered_candidates = Candidate.by_alliance_proportional(result)
      raise "FIXME"

      ordered_candidates.should_not be_empty
      ordered_candidates.each_with_index do |candidate, index|
        next_candidate = ordered_candidates[index+1]
        puts "nro: #{candidate.alliance_proportionals.last.number}"
        candidate.alliance_proportionals.last.number.should < next_candidate if next_candidate
      end

    end

    it 'gives a list of all candidates ordered by their vote sum' do
      candidates = []
      10.times { candidates << FactoryGirl.create(:candidate) }
      VotableSupport::create_votes_for(candidates, @ready_voting_areas, :ascending => true)

      Candidate.by_vote_sum.map(&:id).should == candidates.reverse.map(&:id)
    end

    it 'gives a list of all candidates ordered by their vote sum and excludes unready voting areas' do
      candidates = []
      10.times { candidates << FactoryGirl.create(:candidate) }
      VotableSupport::create_votes_for(candidates, @ready_voting_areas, :ascending => true)
      VotableSupport::create_votes_for(candidates, @unready_voting_areas, :ascending => false, :base_vote_count => 10000)

      Candidate.by_vote_sum.map(&:id).should == candidates.reverse.map(&:id)
    end


    describe 'preliminary votes' do

      before(:each) do
        @candidate = FactoryGirl.create(:candidate)
      end

      it 'has preliminary votes from voting areas which have been fully counted' do
        amount = 10
        @ready_voting_areas.each { |area| FactoryGirl.create(:vote, :candidate => @candidate,
                                                                    :voting_area => area,
                                                                    :amount => amount) }

        @candidate.votes.preliminary_sum.should == amount * @ready_voting_areas.count
      end

      it 'does not add votes from unfinished voting areas to preliminary votes' do
        amount = 10
        [@ready_voting_areas, @unready_voting_areas].each do |area_group|
          area_group.each { |area| FactoryGirl.create(:vote, :candidate => @candidate,
                                                             :voting_area => area,
                                                             :amount => amount) }
        end

        @candidate.votes.preliminary_sum.should == amount * @ready_voting_areas.count
      end

    end
  end

  describe 'votable alliance behaviour' do
    describe 'preliminary votes' do
      before(:each) do
        @alliance = FactoryGirl.create(:electoral_alliance_with_candidates)
      end

      it 'has preliminary votes from voting areas which have been fully counted' do
        amount = 10
        @alliance.candidates.each { |c| VotableSupport::create_votes_for_candidate(c, amount, @ready_voting_areas) }

        @alliance.votes.preliminary_sum.should == amount * @ready_voting_areas.count * @alliance.candidates.count
      end

      it 'does not count votes from unfinished voting areas to preliminary votes' do
        amount = 10
        @alliance.candidates.each do |candidate|
          VotableSupport::create_votes_for_candidate(candidate, amount, @ready_voting_areas)
          VotableSupport::create_votes_for_candidate(candidate, amount, @unready_voting_areas)
        end

        @alliance.votes.preliminary_sum.should == amount * @ready_voting_areas.count * @alliance.candidates.count
      end
    end

  end

  describe 'votable coalition behaviour' do
    describe 'preliminary votes' do
      before(:each) do
        @coalition = FactoryGirl.create(:electoral_coalition_with_alliances_and_candidates)
      end

      it 'has preliminary votes as a sum of alliance votes' do
        amount = 10
        @coalition.electoral_alliances.each { |alliance| VotableSupport::create_votes_for_alliance(alliance, amount, @ready_voting_areas) }

        @coalition.preliminary_vote_sum.should == amount * @ready_voting_areas.count * @coalition.candidates.count
      end

      it 'does not count votes from unfinished voting areas to preliminary votes' do
        amount = 10
        @coalition.electoral_alliances.each do |alliance|
          VotableSupport::create_votes_for_alliance(alliance, amount, @ready_voting_areas)
          VotableSupport::create_votes_for_alliance(alliance, amount, @unready_voting_areas)
        end

        @coalition.preliminary_vote_sum.should == amount * @ready_voting_areas.count * @coalition.candidates.count
      end
    end

  end

end