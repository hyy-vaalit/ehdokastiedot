require 'spec_helper'

describe CandidateAttributeChange do

  it 'creates a new row from attribute' do
    candidate = FactoryGirl.build(:candidate)

    CandidateAttributeChange.create_from!(candidate.id, {"address"=>["Old address", "New address"], "email"=>["old@example.com", "new@example.com"]})

    CandidateAttributeChange.count.should == 2

    c1 = CandidateAttributeChange.first
    c1.attribute_name.should == "address"
    c1.previous_value.should == "Old address"
    c1.new_value.should      == "New address"
    c1.candidate_id.should   == candidate.id

    c2 = CandidateAttributeChange.last
    c2.attribute_name.should == "email"
    c2.previous_value.should == "old@example.com"
    c2.new_value.should      == "new@example.com"
    c2.candidate_id.should   == candidate.id
  end

end
