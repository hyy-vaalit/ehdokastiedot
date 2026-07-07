require 'spec_helper'

describe "Admin emails" do
  before do
    sign_in create(:admin_user)
  end

  it "escapes email content in the preview" do
    email = Email.create!(subject: "Tiedote", content: "<script>alert('xss')</script>")

    get admin_email_path(email)

    expect(response.body).not_to include("<script>alert")
    expect(response.body).to include("&lt;script&gt;")
  end

  it "does not send the same email twice" do
    email = Email.create!(subject: "Tiedote", content: "Sisältö")

    post send_mail_admin_email_path(email)
    expect(Delayed::Job.count).to eq 1

    expect {
      post send_mail_admin_email_path(email)
    }.not_to change { Delayed::Job.count }
    expect(flash[:alert]).to be_present
  end
end
