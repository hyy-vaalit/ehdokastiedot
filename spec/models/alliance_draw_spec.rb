require 'spec_helper'

describe AllianceDraw do

  it 'defines an identifier range character' do
    ad = AllianceDraw.new

    ad.identifier_number = 0
    expect(ad.identifier).to eq 'a'

    ad.identifier_number = 1
    expect(ad.identifier).to eq 'b'

    ad.identifier_number = 26
    expect(ad.identifier).to eq 'aa'

    ad.identifier_number = 18277
    expect(ad.identifier).to eq 'zzz'
  end
end
