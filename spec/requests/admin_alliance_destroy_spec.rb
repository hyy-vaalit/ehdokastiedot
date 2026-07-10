require 'spec_helper'

describe "Admin electoral alliance destroy" do
  before { sign_in create(:admin_user) }

  it "refuses to destroy an alliance with candidates and shows an alert" do
    alliance = create(:electoral_alliance)
    create(:candidate, electoral_alliance: alliance)

    delete admin_electoral_alliance_path(alliance)

    expect(ElectoralAlliance.exists?(alliance.id)).to eq true
    expect(flash[:alert]).to be_present
  end

  it "destroys an alliance without candidates" do
    alliance = create(:electoral_alliance)

    delete admin_electoral_alliance_path(alliance)

    expect(ElectoralAlliance.exists?(alliance.id)).to eq false
  end
end
