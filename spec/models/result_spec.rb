require 'spec_helper'

describe Result do

  it 'should initiate coalition proportional calculations' do
    Result.stub!(:save)
    CoalitionProportional.should_receive(:calculate!)

    Result.create!
  end

  it 'should initiate alliance proportional calculations' do
    AllianceProportional.should_receive(:calculate!)

    Result.create!
  end

  it 'gives /2 of the votes to the candidate with second most votes as a coalition proportional'

  it 'gives /N of the votes to the candidate with Nth most votes as a coalition proportional'

end
