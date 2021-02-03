require 'spec_helper'

describe Result do

  it 'should initiate coalition proportional calculations' do
    allow(CoalitionProportional).to receive(:calculate!)

    Result.create!

    expect(CoalitionProportional).to have_received(:calculate!)
  end

  it 'should initiate alliance proportional calculations' do
    allow(AllianceProportional).to receive(:calculate!)

    Result.create!

    expect(AllianceProportional).to have_received(:calculate!)
  end
end
