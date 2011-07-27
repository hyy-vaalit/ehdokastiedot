require 'spec_helper'

describe ListingsController do

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
