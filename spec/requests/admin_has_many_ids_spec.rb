require 'spec_helper'

# The has_many ids checkbox groups submit arrays. permit_params must declare
# them array-style (ids: []) or strong parameters silently drops them — the
# root cause behind the former create/update controller overrides.
describe "Admin has_many ids assignment" do
  before { sign_in create(:admin_user) }

  it "creates an advocate team with the selected advocates" do
    primary = create(:advocate_user)
    member = create(:advocate_user)

    post admin_advocate_teams_path, params: {
      advocate_team: {
        name: "Tiimi",
        primary_advocate_user_id: primary.id,
        advocate_user_ids: ["", member.id.to_s]
      }
    }

    team = AdvocateTeam.find_by(name: "Tiimi")
    expect(team).to be_present
    expect(team.advocate_users).to include(member)
  end

  it "updates a coalition's alliances, including clearing the selection" do
    coalition = create(:electoral_coalition)
    alliance = create(:electoral_alliance, electoral_coalition: nil)

    patch admin_electoral_coalition_path(coalition), params: {
      electoral_coalition: { electoral_alliance_ids: ["", alliance.id.to_s] }
    }
    expect(coalition.reload.electoral_alliances).to include(alliance)

    # Empty checkbox group submits only the blank hidden field.
    patch admin_electoral_coalition_path(coalition), params: {
      electoral_coalition: { electoral_alliance_ids: [""] }
    }
    expect(coalition.reload.electoral_alliances).to be_empty
  end

  it "updates an advocate's alliances" do
    advocate = create(:advocate_user)
    alliance = create(:electoral_alliance)

    patch admin_advocate_user_path(advocate), params: {
      advocate_user: { electoral_alliance_ids: ["", alliance.id.to_s] }
    }

    expect(advocate.reload.electoral_alliances).to include(alliance)
  end
end
