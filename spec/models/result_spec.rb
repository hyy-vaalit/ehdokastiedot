require 'spec_helper'

describe Result do

  it 'should initiate coalition proportional calculations' do
    CoalitionProportional.should_receive(:calculate!)

    Result.create!
  end

  it 'should initiate alliance proportional calculations' do
    AllianceProportional.should_receive(:calculate!)

    Result.create!
  end
end
