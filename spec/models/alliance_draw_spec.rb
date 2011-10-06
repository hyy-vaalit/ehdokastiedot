require 'spec_helper'

describe AllianceDraw do

  it 'defines an identifier range character' do
    ad = AllianceDraw.new

    ad.identifier_number = 0
    ad.identifier.should == 'a'

    ad.identifier_number = 1
    ad.identifier.should == 'b'

    ad.identifier_number = 26
    ad.identifier.should == 'aa'

    ad.identifier_number = 18277
    ad.identifier.should == 'zzz'
  end
end
