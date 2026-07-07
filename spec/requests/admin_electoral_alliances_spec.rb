require 'spec_helper'

describe "Admin electoral alliance freeze (done)" do
  let(:alliance) do
    create(:electoral_alliance, secretarial_freeze: false, expected_candidate_count: 1)
  end

  before do
    create(:candidate, electoral_alliance: alliance, alliance_accepted: true)
    sign_in create(:admin_user)
  end

  it "freezes the alliance via POST" do
    post done_admin_electoral_alliance_path(alliance)

    expect(response).to redirect_to(admin_electoral_alliances_path)
    expect(alliance.reload.secretarial_freeze).to eq true
  end

  it "does not respond to GET (CSRF protection)" do
    get done_admin_electoral_alliance_path(alliance)

    expect(response).to have_http_status(:not_found)
    expect(alliance.reload.secretarial_freeze).to eq false
  end
end
