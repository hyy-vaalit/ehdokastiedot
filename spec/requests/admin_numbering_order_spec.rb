require 'spec_helper'

describe "Admin numbering order endpoints" do
  before { sign_in create(:admin_user) }

  let!(:coalition) { create(:electoral_coalition) }
  let!(:alliance) { create(:electoral_alliance, electoral_coalition: coalition) }

  it "orders alliances within a coalition" do
    post order_alliances_admin_electoral_coalition_path(coalition),
      params: { alliances: { alliance.id.to_s => "7" } }

    expect(response).to redirect_to(admin_electoral_coalition_path(coalition.id))
    expect(alliance.reload.numbering_order).to eq 7
  end

  it "does not crash when the alliances param is missing" do
    post order_alliances_admin_electoral_coalition_path(coalition)

    expect(response).to redirect_to(admin_electoral_coalition_path(coalition.id))
  end

  it "does not crash when the coalitions param is missing" do
    post order_coalitions_admin_electoral_coalitions_path

    expect(response).to redirect_to(admin_electoral_coalitions_path)
  end
end
