require 'spec_helper'

# Smoke tests for the request spec authentication helpers in spec/support.
describe "Authentication helpers" do
  it "signs in a Haka user via fake authentication" do
    sign_in_haka "012345678"
    expect(response).to redirect_to(registrations_root_path)

    get registrations_root_path
    expect(response).to have_http_status(:ok)
  end

  it "signs in an admin user with Devise helpers" do
    create(:global_configuration)

    sign_in create(:admin_user)
    get admin_dashboard_path
    expect(response).to have_http_status(:ok)
  end

  it "leaves guests unauthorized" do
    get registrations_root_path
    expect(response).to have_http_status(:unauthorized)
  end
end
