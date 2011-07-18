require 'spec_helper'
require "cancan/matchers"

describe Ability do

  it "should let admin manage everything" do
    user = AdminUser.new :role => 'admin'
    ability = Ability.new(user)
    ability.should be_able_to(:manage, :all)
  end

  it "should let secretary to edit linked electoral alliance before data freeze"

  it "should let advocate to edit own electoral alliance data"

end
