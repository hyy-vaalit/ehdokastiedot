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

    expect(Candidate.give_numbers!).to eq true

    all_candidates = Candidate.all

    expect(all_candidates.first.candidate_number).to eq 2

    all_candidates.each_with_index do |candidate, i|
      if not all_candidates[i] == all_candidates.last
        # FIXME: flaky test fails sometimes
        expect(1 + all_candidates[i].candidate_number).to eq(all_candidates[i+1].candidate_number)
      end
    end
  end
end
