require 'spec_helper'

describe Advocate do

  before :each do
    @advocate = Advocate.new
  end

  describe "are able to be nominated" do

    it "should be nominated if person is nominated to be primary advocate" do
      @advocate.primary_nominated = ElectoralAlliance.new
      @advocate.nominated.should_not be_nil
    end

    it "should be nominated if person is nominated to be secondary advocate" do
      @advocate.secondary_nominated = ElectoralAlliance.new
      @advocate.nominated.should_not be_nil
    end

    it "shouldn't be nominated if person is nominated to be neither primary or secondary advocate" do
      @advocate.nominated.should be_nil
    end

  end

  it "should have formatted name" do
    lastname = "Doe"
    firstname = "Jane"
    @advocate.lastname = lastname
    @advocate.firstname = firstname
    @advocate.name.should == "#{lastname} #{firstname}"
  end

end
