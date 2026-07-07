require 'spec_helper'

# The unique indexes back up model validations that are race-prone on
# their own (and give_numbers!, which bypasses validations entirely).
describe "Database constraints" do
  it "rejects duplicate candidate numbers" do
    a = create(:candidate)
    b = create(:candidate)
    a.update_column(:candidate_number, 2)

    expect {
      b.update_column(:candidate_number, 2)
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "rejects duplicate advocate student numbers" do
    advocate = create(:advocate_user)
    copy = build(:advocate_user, student_number: advocate.student_number)

    expect {
      copy.save(validate: false)
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
