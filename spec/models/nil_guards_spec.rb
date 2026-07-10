require 'spec_helper'

# Regression specs: nil input must produce a validation error or a false
# return value, never a NoMethodError.
describe "Nil guards" do
  describe ElectoralAlliance do
    it "is invalid without a name instead of crashing in before_validation" do
      alliance = build(:electoral_alliance, name: nil, shorten: nil, invite_code: nil)

      expect(alliance.valid?).to eq false
      expect(alliance.errors[:name]).to be_present
    end

    it "is invalid without expected_candidate_count" do
      alliance = build(:electoral_alliance, expected_candidate_count: nil)

      expect(alliance.valid?).to eq false
      expect(alliance.errors[:expected_candidate_count]).to be_present
    end

    it "has_all_candidates? is false when expected_candidate_count is nil" do
      alliance = build(:electoral_alliance, expected_candidate_count: nil)

      expect(alliance.has_all_candidates?).to eq false
    end
  end

  describe ElectoralCoalition do
    it "is invalid without a name instead of crashing in before_validation" do
      coalition = build(:electoral_coalition, name: nil, shorten: nil)

      expect(coalition.valid?).to eq false
      expect(coalition.errors[:name]).to be_present
    end
  end

  describe GlobalConfiguration do
    it "advocate_login_enabled? is false when the table is empty" do
      expect(GlobalConfiguration.count).to eq 0
      expect(GlobalConfiguration.advocate_login_enabled?).to eq false
    end
  end
end
