require 'spec_helper'

describe AdminUser do

  it "should have generated password after creation" do
    user = AdminUser.new
    expect(user.encrypted_password).to eq ""
    user.save :validation => false
    expect(user.encrypted_password).not_to eq ""
  end

  it "generates a 20 character initial password" do
    user = create(:admin_user)
    expect(user.password.length).to eq 20
  end

end
