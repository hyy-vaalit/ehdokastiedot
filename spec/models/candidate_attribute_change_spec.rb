require 'spec_helper'

describe CandidateAttributeChange do

  it 'creates a new row from attribute' do
    candidate = FactoryBot.create(:candidate)

    CandidateAttributeChange.create_from!(candidate.id, {"address"=>["Old address", "New address"], "email"=>["old@example.com", "new@example.com"]})

    expect(CandidateAttributeChange.count).to eq 2

    c1 = CandidateAttributeChange.first
    expect(c1.attribute_name).to eq "address"
    expect(c1.previous_value).to eq "Old address"
    expect(c1.new_value).to eq "New address"
    expect(c1.candidate_id).to eq candidate.id

    c2 = CandidateAttributeChange.last
    expect(c2.attribute_name).to eq "email"
    expect(c2.previous_value).to eq "old@example.com"
    expect(c2.new_value).to eq "new@example.com"
    expect(c2.candidate_id).to eq candidate.id
  end
end
