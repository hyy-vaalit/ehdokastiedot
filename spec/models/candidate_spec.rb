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

    Candidate.give_numbers!.should be true

    all_candidates = Candidate.all

    all_candidates.first.candidate_number.should == 2
    all_candidates.each_with_index do |candidate, i|
      (1 + all_candidates[i].candidate_number).should == all_candidates[i+1].candidate_number if not all_candidates[i] == all_candidates.last
    end

  end
end
