require 'spec_helper'

describe 'votable behaviour' do

  before(:all) do
    @result = FactoryGirl.create(:result_with_coalition_proportionals_and_candidates)
    @decorator = ResultDecorator.find(@result)
  end

  it 'formats the whole candidate line' do
    candidate = Factory.build(:candidate)
    alliance = "Tumpit"
    candidate_name = "Testinen, Martti 'Sakke'"
    idx = 123
    cno = 789
    votes = 42
    cprop = 123.45678
    aprop = 432.12345
    candidate.electoral_alliance.stub!(:shorten).and_return(alliance)
    candidate.stub!(:candidate_name).and_return(candidate_name)
    candidate.stub!(:candidate_number).and_return(cno)
    candidate.stub!(:vote_sum).and_return(votes)
    candidate.stub!(:alliance_proportional).and_return(aprop)
    candidate.stub!(:coalition_proportional).and_return(cprop)

    # TODO: state char is not stubbed
    expected = " #{idx+1}* #{candidate_name}...... #{cno} #{alliance}  #{votes}  #{aprop}  #{cprop}"
    @decorator.candidate_result_line(candidate, idx).should == expected
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

  it 'formats candidate number' do
    @decorator.formatted_candidate_number(nil).should     == "   0"
    @decorator.formatted_candidate_number("1").should     == "   1"
    @decorator.formatted_candidate_number("10").should    == "  10"
    @decorator.formatted_candidate_number("100").should   == " 100"
    @decorator.formatted_candidate_number("1000").should  == "1000"
  end

  it 'formats proportional number' do
    precision = Vaalit::Voting::PROPORTIONAL_PRECISION
    @decorator.formatted_proportional_number(nil).should   ==  "   0." + "0" * precision
    @decorator.formatted_proportional_number(0.0).should   ==  "   0." + "0" * precision
    @decorator.formatted_proportional_number(1.123).should ==  "   1.123" + "0" * (precision-3)
    @decorator.formatted_proportional_number(1).should     ==  "   1." + "0" * precision
    @decorator.formatted_proportional_number(10).should    ==  "  10." + "0" * precision
    @decorator.formatted_proportional_number(100).should   ==  " 100." + "0" * precision
    @decorator.formatted_proportional_number(1000).should  ==  "1000." + "0" * precision
    @decorator.formatted_proportional_number(10000).should ==  "10000." + "0" * precision
  end

  it 'formats vote sum' do
    @decorator.formatted_vote_sum(nil).should  == "    "
    @decorator.formatted_vote_sum(0).should    == "   0"
    @decorator.formatted_vote_sum(1).should    == "   1"
    @decorator.formatted_vote_sum(10).should   == "  10"
    @decorator.formatted_vote_sum(100).should  == " 100"
    @decorator.formatted_vote_sum(1000).should == "1000"
  end

  it 'formats character which shows whether the candidate has been elected'

  it 'formats dots after the candidate name' do
    max_count = 30
    @decorator.formatted_candidate_name_with_dots("").should           == "." * max_count
    ["Short Name", "Li Ly", "Normalissimo Namismo 'Nickname'", "Very Very Very Very Very Very Very Very Very, Long NAME 'and nickname'"].each do |name|
      @decorator.formatted_candidate_name_with_dots(name).should == name + "." * how_many_dots(name, max_count)
    end
  end

  def how_many_dots(name, max_count)
    count = max_count - name.length
    count = 0 if count < 0

    count
  end

  # def formatted_state_char(candidate_name)
  #   "X #{candidate_name}"
  # end
  #
end