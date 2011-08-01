require 'spec_helper'

describe ListingsController do
  include Devise::TestHelpers

  before :each do
    @user = FactoryGirl.create(:admin_user, :role => 'admin')
    sign_in @user
  end

  describe "GET 'same_ssn'" do
    it "should be successful" do
      get 'same_ssn'
      response.should be_success
    end
  end

  describe "GET 'simple'" do
    it "should be successful" do
      get 'simple'
      response.should be_success
    end
  end

end
