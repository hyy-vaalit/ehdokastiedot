require 'spec_helper'

describe Candidate do

  it 'can give candidate numbers' do
    2.times do |i|
      coalition = FactoryGirl.create(:electoral_coalition)
      3.times do
        FactoryGirl.create_list(:candidate, 20, :electoral_alliance => FactoryGirl.create(:electoral_alliance, :electoral_coalition => coalition))
      end
    end

    10.times do
      FactoryGirl.create(:candidate)
    end

    Candidate.give_numbers!

    all_candidates = Candidate.all
    all_candidates.map(&:candidate_number).each do |cn|
      cn.should_not be_nil
    end
  end

  describe 'votable behaviour' do

    describe 'preliminary votes' do
      before(:each) do
        @candidate = FactoryGirl.create(:candidate)
        @taken_voting_areas = []
        3.times do
          v = FactoryGirl.create :voting_area, :ready => true
          @taken_voting_areas << v
        end

        @untaken_voting_areas = []
        3.times do
          v = FactoryGirl.create :voting_area, :ready => false
          @untaken_voting_areas << v
        end
      end

      it 'has preliminary votes from voting areas which have been fully counted' do
        amount = 10
        @taken_voting_areas.each { |area| FactoryGirl.create(:vote, :amount => amount, :voting_area => area, :candidate => @candidate) }

        @candidate.votes.preliminary_sum.should == amount * @taken_voting_areas.size
      end

      it 'does not add votes from unfinished voting areas to preliminary votes' do
        amount = 10
        @taken_voting_areas.each { |area| create_votes_for(@candidate, area, amount) }
        @untaken_voting_areas.each { |area| create_votes_for(@candidate, area, amount) }
        @candidate.votes.preliminary_sum.should == amount * @taken_voting_areas.size
      end

      def create_votes_for(candidate, area, amount)
        FactoryGirl.create(:vote, :amount => amount, :voting_area => area, :candidate => candidate)
      end

    end
  end
end
