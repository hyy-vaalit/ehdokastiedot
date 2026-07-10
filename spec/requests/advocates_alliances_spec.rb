require 'spec_helper'

describe "Advocate alliance access" do
  before { create(:global_configuration) }

  let(:team) { create(:advocate_team) }
  let(:owner) do
    create(:advocate_user, student_number: "111", advocate_team: team)
  end
  let(:teammate) do
    create(:advocate_user, student_number: "222", advocate_team: team)
  end
  let(:coalition) { create(:electoral_coalition, advocate_team: team) }
  let!(:alliance) do
    create(:electoral_alliance,
      electoral_coalition: coalition,
      advocate_user: owner,
      name: "Alkuperäinen nimi")
  end

  describe "a team member who does not own the alliance" do
    before { sign_in_haka teammate.student_number }

    it "can view it" do
      get advocates_alliance_path(alliance)
      expect(response).to have_http_status(:ok)
    end

    it "cannot open the edit form" do
      get edit_advocates_alliance_path(alliance)
      expect(response).to redirect_to(advocates_alliances_path)
    end

    it "cannot update it" do
      patch advocates_alliance_path(alliance),
        params: { electoral_alliance: { name: "Muutettu nimi" } }

      expect(response).to redirect_to(advocates_alliances_path)
      expect(alliance.reload.name).to eq "Alkuperäinen nimi"
    end
  end

  describe "the owning advocate" do
    before { sign_in_haka owner.student_number }

    it "can update the alliance" do
      patch advocates_alliance_path(alliance),
        params: { electoral_alliance: { name: "Muutettu nimi" } }

      expect(alliance.reload.name).to eq "Muutettu nimi"
    end
  end

  describe "an advocate without a team" do
    let(:outsider) { create(:advocate_user, student_number: "333") }

    before { sign_in_haka outsider.student_number }

    it "is redirected instead of crashing when viewing a foreign alliance" do
      get advocates_alliance_path(alliance)
      expect(response).to redirect_to(advocates_alliances_path)
    end
  end
end
