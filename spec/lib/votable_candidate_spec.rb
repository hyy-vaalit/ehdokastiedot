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

      it 'has preliminary votes from voting areas which have been fully counted' do
        amount = 10
        @alliance = FactoryGirl.create(:electoral_alliance_with_candidates)
        @alliance.candidates.each { |c| create_votes_for(c, amount, @ready_voting_areas) }

        expected_count = 0
        @alliance.candidates.each {|c| expected_count += c.votes.preliminary_sum }
        #@alliance.votes.preliminary_sum.should == amount * @ready_voting_areas.count * @alliance.candidates.count + 1
        @alliance.reload
        @alliance.votes.should_not be_empty
        @alliance.votes.preliminary_sum.should == expected_count
      end
    #
    #   it 'does not count votes from unfinished voting areas to preliminary votes' do
    #     amount = 10
    #     @alliance.candidates.should_not be_empty
    #     @alliance.candidates.each do |candidate|
    #       @ready_voting_areas.each { |area| create_votes_for(candidate, area, amount) }
    #       @unready_voting_areas.each { |area| create_votes_for(candidate, area, amount) }
    #     end
    #     puts "alliance votes: #{@alliance.votes}"
    #     @alliance.candidates.each {|c| puts c.votes.preliminary_sum.inspect}
    #     puts "lkm: #{@alliance.candidates.inspect}"
    #     @alliance.votes.preliminary_sum.should == amount * @ready_voting_areas.size
    #     @alliance.votes.sum("amount").should == amount * @ready_voting_areas.size * @unready_voting_areas.size
    #   end
    end

  end

  def create_votes_for(candidate, amount, voting_areas)
    voting_areas.each do |area|
      FactoryGirl.create(:vote, :candidate => candidate, :voting_area => area, :amount => amount)
    end
  end
end