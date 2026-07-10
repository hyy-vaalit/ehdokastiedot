require 'spec_helper'

describe "Welcome emails" do
  it "are sent when an admin user is created" do
    expect {
      create(:admin_user)
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "are sent when an advocate user is created" do
    expect {
      create(:advocate_user)
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
