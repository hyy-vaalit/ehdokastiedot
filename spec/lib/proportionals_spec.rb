require 'spec_helper'

describe Proportionals do

  before :each do
    20.times { FactoryGirl.create(:voting_area) }
  end

  describe "in normal case" do

    before :each do

      @coalition = FactoryGirl.create :electoral_coalition
      5.times do |n|
        alliance = FactoryGirl.create :electoral_alliance, :electoral_coalition => @coalition
        20.times do |i|
          candidate = FactoryGirl.create(:candidate, :electoral_alliance => alliance)
          VotingArea.all.each do |va|
            FactoryGirl.create(:vote, :candidate => candidate, :voting_area => va)
          end
        end
      end

      Proportionals.calculus!
    end

    it "should do calculus for electoral alliances" do
      @coalition.electoral_alliances.each do |alliance|
        total_vote_count = alliance.total_votes
        candidates = alliance.candidates.sort {|x,y| x.total_votes <=> y.total_votes}
        candidates.each_with_index do |candidate, i|
          candidate.alliance_proportional.should == (total_vote_count/(i+1))
        end
      end
    end

    it "should do calculus for electoral coalitions" do
      total_vote_count = @coalition.total_votes
      candidates = @coalition.electoral_alliances.map(&:candidates).flatten.sort {|x,y| x.total_votes <=> y.total_votes}
      candidates.each_with_index do |candidate, i|
        candidate.coalition_proportional.should == (total_vote_count/(i+1))
      end
    end

  end

  describe "under odd circumstances" do

    it "should do calculus for electoral coalitions, when no coalition is set" do
      alliance = FactoryGirl.create :electoral_alliance, :electoral_coalition => nil
      candidate = FactoryGirl.create :candidate, :electoral_alliance => alliance
      20.times do |i|
        VotingArea.all.each do |va|
          FactoryGirl.create(:vote, :candidate => candidate, :voting_area => va)
        end
      end

      Proportionals.calculus!

      Candidate.all.each do |candidate|
        candidate.coalition_proportional.should_not be_nil
        candidate.alliance_proportional.should_not be_nil
        candidate.coalition_proportional.should == candidate.alliance_proportional
      end
    end

  end

end
