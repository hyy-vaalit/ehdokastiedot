require 'spec_helper'

describe CoalitionProportional do


  it 'gives all the votes of a coalition to the candidate with most votes as a coalition proportional' do
    coalition =  FactoryGirl.create(:electoral_coalition_with_alliances_and_candidates)
    candidates_by_vote_sum = []

    vote_sum = 0
    total_vote_sum = 0

    coalition.candidates.each do |c|
      c.should_receive(:vote_sum).and_return(vote_sum)
      total_vote_sum += vote_sum
      vote_sum += 10
    end

    #ElectoralCoalition.should_receive(:preliminary_vote_sum).and_return(total_vote_sum)
    CoalitionProportional.calculate!

    coalition.candidates.each_with_index do |candidate, index|
      #candidate.reload
      puts "#{candidate.vote_sum}: #{total_vote_sum / (coalition.candidates.count - index)}"
      candidate.coalition_proportional.should == total_vote_sum / (coalition.candidates.count - index)
    end

  end

end
