require 'spec_helper'

describe "Manage pages authorization" do
  before { create(:global_configuration) }

  it "allows admins" do
    sign_in create(:admin_user)

    get manage_candidates_path
    expect(response).to have_http_status(:ok)

    get manage_danger_zone_path
    expect(response).to have_http_status(:ok)

    get manage_candidate_attribute_changes_path
    expect(response).to have_http_status(:ok)
  end

  it "shows the manage links on the admin dashboard" do
    sign_in create(:admin_user)

    get admin_dashboard_path
    expect(response.body).to include("Ylläpidon toiminnot")
  end

  it "redirects guests to the admin login" do
    get manage_candidates_path
    expect(response).to redirect_to(new_admin_user_session_path)
  end

  it "redirects Haka users to the admin login" do
    sign_in_haka "012345678"

    get manage_candidates_path
    expect(response).to redirect_to(new_admin_user_session_path)
  end
end
