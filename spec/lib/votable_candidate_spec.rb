require 'spec_helper'

describe 'votable behaviour' do
  before(:each) do
    @candidate = FactoryGirl.create(:candidate)
    @ready_voting_areas = []
    @unready_voting_areas = []
    3.times { @ready_voting_areas << FactoryGirl.create(:ready_voting_area) }
    3.times { @unready_voting_areas << FactoryGirl.create(:unready_voting_area) }
  end

  describe 'votable candidates' do

    describe 'preliminary votes' do


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
        @alliance.candidates.each { |c| create_votes_for_candidate(c, amount, @ready_voting_areas) }

        @alliance.votes.preliminary_sum.should == amount * @ready_voting_areas.count * @alliance.candidates.count
      end

      it 'does not count votes from unfinished voting areas to preliminary votes' do
        amount = 10
        @alliance.candidates.each do |candidate|
          create_votes_for_candidate(candidate, amount, @ready_voting_areas)
          create_votes_for_candidate(candidate, amount, @unready_voting_areas)
        end

        @alliance.votes.preliminary_sum.should == amount * @ready_voting_areas.count * @alliance.candidates.count
      end
    end

  end

  describe 'votable coalition behaviour' do
    describe 'preliminary votes' do
      before(:each) do
        @coalition = FactoryGirl.create(:electoral_coalition_with_alliances)
      end

      it 'has preliminary votes as a sum of alliance votes' do
        amount = 10
        @coalition.electoral_alliances.each { |alliance| create_votes_for_alliance(alliance, amount, @ready_voting_areas) }

        @coalition.preliminary_vote_sum.should == amount * @ready_voting_areas.count * @coalition.candidates.count
      end

      it 'does not count votes from unfinished voting areas to preliminary votes' do
        amount = 10
        @coalition.electoral_alliances.each do |alliance|
          create_votes_for_alliance(alliance, amount, @ready_voting_areas)
          create_votes_for_alliance(alliance, amount, @unready_voting_areas)
        end

        @coalition.preliminary_vote_sum.should == amount * @ready_voting_areas.count * @coalition.candidates.count
      end
    end

  end

  def create_votes_for_alliance(alliance, amount, voting_areas)
    alliance.candidates.each { |c| create_votes_for_candidate(c, amount, voting_areas) }
  end

  def create_votes_for_candidate(candidate, amount, voting_areas)
    voting_areas.each do |area|
      FactoryGirl.create(:vote, :candidate => candidate, :voting_area => area, :amount => amount)
    end
  end
end