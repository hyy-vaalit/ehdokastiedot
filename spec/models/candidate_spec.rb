require 'spec_helper'

describe Candidate do
  describe "#log_and_update_attributes" do
    before do
      allow(GlobalConfiguration).to receive(:log_candidate_attribute_changes?).and_return(true)
    end

    it "writes no audit rows when the save fails" do
      candidate = FactoryBot.create(:candidate)

      result = candidate.log_and_update_attributes(email: "")

      expect(result).to eq false
      expect(CandidateAttributeChange.count).to eq 0
    end

    it "writes audit rows for the changed attributes on success" do
      candidate = FactoryBot.create(:candidate)

      result = candidate.log_and_update_attributes(phone_number: "040 555 6677")

      expect(result).to eq true

      changes = CandidateAttributeChange.where(candidate_id: candidate.id)
      expect(changes.count).to eq 1
      expect(changes.first.attribute_name).to eq "phone_number"
      expect(changes.first.new_value).to eq "040 555 6677"
    end
  end

  it 'can give candidate numbers' do
    2.times do |i|
      coalition = FactoryBot.create(:electoral_coalition)
      3.times do
        FactoryBot.create_list(:candidate, 20, :electoral_alliance => FactoryBot.create(:electoral_alliance, :electoral_coalition => coalition))
      end
    end

    10.times do
      FactoryBot.create(:candidate)
    end

    expect(Candidate.give_numbers!).to eq true

    all_candidates = Candidate.by_candidate_number

    expect(all_candidates.first.candidate_number).to eq 2
    expect(all_candidates.last.candidate_number).to eq(Candidate.count + 1)

    all_candidates.each.with_index(2) do |c, i|
      expect(c.candidate_number).to eq i
    end
  end

  it 'leaves cancelled candidates without a candidate number' do
    alliance = FactoryBot.create(:electoral_alliance)
    FactoryBot.create_list(:candidate, 3, :electoral_alliance => alliance)
    cancelled = FactoryBot.create(:candidate, :electoral_alliance => alliance)
    cancelled.cancel

    expect(Candidate.give_numbers!).to eq true

    expect(cancelled.reload.candidate_number).to be_nil
    expect(Candidate.valid.where(:candidate_number => nil)).to be_empty
  end
end
