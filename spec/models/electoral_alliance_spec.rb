require 'spec_helper'

describe ElectoralAlliance do
  describe "#destroy" do
    it "is blocked when the alliance has candidates" do
      alliance = create(:electoral_alliance)
      create(:candidate, electoral_alliance: alliance)

      expect(alliance.destroy).to eq false
      expect(alliance.errors[:base]).to be_present
      expect(ElectoralAlliance.exists?(alliance.id)).to eq true
    end

    it "destroys an alliance without candidates" do
      alliance = create(:electoral_alliance)

      expect(alliance.destroy).to be_truthy
      expect(ElectoralAlliance.exists?(alliance.id)).to eq false
    end
  end
end
