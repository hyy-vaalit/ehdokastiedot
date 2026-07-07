require 'spec_helper'

describe Ability do
  describe "advocate user during nomination period" do
    let(:advocate) { create(:advocate_user) }
    let(:haka_user) do
      HakaUser.new(attrs: {
        student_number: ["#{Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY}:#{advocate.student_number}"]
      })
    end

    before { create(:global_configuration) }

    it "can update candidates only in own alliances" do
      own_candidate = create(:candidate,
        electoral_alliance: create(:electoral_alliance, advocate_user: advocate))
      foreign_candidate = create(:candidate)

      ability = Ability.new(haka_user)

      expect(ability.can?(:update, own_candidate)).to eq true
      expect(ability.can?(:update, foreign_candidate)).to eq false
    end

    it "still allows a haka user to update their own candidacy" do
      own_candidacy = create(:candidate, student_number: advocate.student_number)

      expect(Ability.new(haka_user).can?(:update, own_candidacy)).to eq true
    end
  end
end
