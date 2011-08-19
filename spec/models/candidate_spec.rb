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

end
