require 'spec_helper'

describe AdminUser do

  it "should have generated password after creation" do
    user = AdminUser.new
    expect(user.encrypted_password).to eq ""
    user.save :validation => false
    expect(user.encrypted_password).not_to eq ""
  end

end
