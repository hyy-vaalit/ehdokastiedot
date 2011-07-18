require 'spec_helper'

describe AdminUser do

  it "should have generated password after creation" do
    user = AdminUser.new
    user.encrypted_password.should == ""
    user.save :validation => false
    user.encrypted_password.should_not == ""
  end

end
