require 'spec_helper'

describe 'votable behaviour' do

  before(:all) do
    @result = FactoryGirl.create(:result_with_coalition_proportionals_and_candidates)
    @decorator = ResultDecorator.find(@result)
  end

  it 'formats candidate order number' do
    @decorator.formatted_order_number(1).should    == "   1"
    @decorator.formatted_order_number(10).should   == "  10"
    @decorator.formatted_order_number(100).should  == " 100"
    @decorator.formatted_order_number(1000).should == "1000"
  end


  it 'formats candidate_number' do
    @decorator.formatted_candidate_number(1).should      == "   1"
    @decorator.formatted_candidate_number(10).should     == "  10"
    @decorator.formatted_candidate_number(100).should    == " 100"
    @decorator.formatted_candidate_number(1000).should   == "1000"
  end

  it 'formats alliance name' do
    @decorator.formatted_alliance_name("Short").should     == " Short"
    @decorator.formatted_alliance_name("Enough").should    == "Enough"
    @decorator.formatted_alliance_name("Too Long").should  == "Too Long" # FIXME: truncate or not?
    @decorator.formatted_alliance_name("").should          == "      "
  end

  # TODO:
  #
  # def formatted_state_char(candidate_name)
  #   "X #{candidate_name}"
  # end
  #
  # def formatted_candidate_number(number)
  #   sprintf "%3d", number
  # end
  #
  # def formatted_dots_after_candidate_name(candidate_name)
  #   "..clip.. #{candidate_name}"
  # end
  #
  # def formatted_vote_sum(number)
  #   sprintf "%3s", number # FIXME: entäs neljänumeroinen ääniämäärä?
  # end
  #
  # def formatted_proportional_number(number)
  #   sprintf "%10.5f", number
  # end
end