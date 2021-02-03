require 'spec_helper'

describe 'votable behaviour' do

  before(:all) do
    @result = FactoryGirl.create(:result_with_coalition_proportionals_and_candidates)
    @decorator = ResultDecorator.decorate(@result)
  end

  it 'formats the whole candidate line' do
    candidate = CandidateResult.new
    alliance = "Tumpit"
    candidate_name = "Testinen, Martti 'Sakke'"
    idx = 123
    cno = 789
    votes = 42
    cprop = 123.45678
    aprop = 432.12345
    candidate_draw = "ax"
    alliance_draw = "ay"
    coalition_draw = " a"
    allow(candidate).to receive(:electoral_alliance_shorten).and_return(alliance)
    allow(candidate).to receive(:candidate_name).and_return(candidate_name)
    allow(candidate).to receive(:candidate_number).and_return(cno)
    allow(candidate).to receive(:vote_sum).and_return(votes)
    allow(candidate).to receive(:elected?).and_return(true)
    allow(candidate).to receive(:candidate_draw_identifier).and_return(candidate_draw)
    allow(candidate).to receive(:alliance_draw_identifier).and_return(alliance_draw)
    allow(candidate).to receive(:coalition_draw_identifier).and_return(coalition_draw)
    allow(candidate).to receive(:alliance_proportional).and_return(aprop)
    allow(candidate).to receive(:coalition_proportional).and_return(cprop)
    allow(candidate).to receive(:candidate_draw_affects_elected?).and_return(false)
    allow(candidate).to receive(:alliance_draw_affects_elected?).and_return(false)
    allow(candidate).to receive(:coalition_draw_affects_elected?).and_return(false)

    # "124* Testinen, Martti 'Sakke'...... 789 Tumpit   42ax  432.12345    123.45678 a"
    expected = "#{idx+1}* #{candidate_name}...... #{cno} #{alliance}   #{votes}#{candidate_draw}  #{aprop}#{alliance_draw}  #{cprop}#{coalition_draw}"
    expect(@decorator.candidate_result_line(candidate, idx)).to eq expected
  end

  it 'formats the coalition result line' do
    vote_sum = 1234
    coalition_result = FactoryGirl.build(:coalition_result, :vote_sum_cache => vote_sum)
    coalition = coalition_result.electoral_coalition
    places    = 0
    idx       = 1
    dot_count = 66 - coalition.name.length - coalition.shorten.length

    expected = "  #{idx+1}. #{coalition.name}#{'.' * dot_count}#{coalition.shorten} #{vote_sum}  #{places}"

    expect(@decorator.coalition_result_line(coalition_result, idx)).to eq expected
  end

  it 'formats the alliance result line' do
    vote_sum = 1234
    alliance_result = FactoryGirl.build(:alliance_result, :vote_sum_cache => vote_sum)
    alliance = alliance_result.electoral_alliance
    places   = 0
    idx      = 1
    dot_count = 58 - alliance.name.length - alliance.shorten.length

    # 1. HYYn Vihreät - De Gröna vid HUS........................HyVi MP     1045  4
    expected = "  #{idx+1}. #{alliance.name}#{'.' * dot_count}.#{alliance.shorten} #{alliance.electoral_coalition.shorten}   #{vote_sum}  #{places}"

    expect(@decorator.alliance_result_line(alliance_result, idx)).to eq expected
  end

  it 'formats a long alliance result line' do
    vote_sum = 1234
    alliance_result = FactoryGirl.build(:alliance_result, :vote_sum_cache => vote_sum)
    coalition = "MP"
    alliance_shorten = "SitVas"
    alliance_name           = "Sitoutumaton vasemmisto - Obunden vänster - Independent Left"
    truncated_alliance_name = "Sitoutumaton vasemmisto - Obunden vänster - Independ"
    alliance = alliance_result.electoral_alliance
    allow(alliance).to receive(:name).and_return(alliance_name)
    allow(alliance).to receive(:shorten).and_return(alliance_shorten)
    allow(alliance.electoral_coalition).to receive(:shorten).and_return(coalition)
    places   = 0
    idx      = 1
    dot_count = 1

    # 2. Sitoutumaton vasemmisto - Obunden vänster - Independe.SitVas MP       96  5
    expected = "  #{idx+1}. #{truncated_alliance_name}.#{alliance_shorten} #{coalition}     #{vote_sum}  #{places}"

    expect(@decorator.alliance_result_line(alliance_result, idx)).to eq expected
  end

  it 'generates dot fillings' do
    line_width = 100
    words = ["eka", "toka"]
    expected_dot_count = 100 - words.first.length - words.last.length

    expect(@decorator.fill_dots(line_width, words.first, words.last)).to eq('.' * expected_dot_count)
  end

  it 'formats candidate order number' do
    expect(@decorator.formatted_order_number(1)).to eq "  1"
    expect(@decorator.formatted_order_number(10)).to eq " 10"
    expect(@decorator.formatted_order_number(100)).to eq "100"
    expect(@decorator.formatted_order_number(1000)).to eq "1000"
  end


  it 'formats candidate_number' do
    expect(@decorator.formatted_candidate_number(1)).to eq "   1"
    expect(@decorator.formatted_candidate_number(10)).to eq "  10"
    expect(@decorator.formatted_candidate_number(100)).to eq " 100"
    expect(@decorator.formatted_candidate_number(1000)).to eq "1000"
  end

  it 'formats alliance name' do
    expect(@decorator.formatted_alliance_shorten("Short")).to eq " Short"
    expect(@decorator.formatted_alliance_shorten("Enough")).to eq "Enough"
    expect(@decorator.formatted_alliance_shorten("TooMuch")).to eq "TooMuc"
    expect(@decorator.formatted_alliance_shorten("")).to eq "      "
  end

  it 'formats candidate number' do
    expect(@decorator.formatted_candidate_number(nil)).to eq "   0"
    expect(@decorator.formatted_candidate_number("1")).to eq "   1"
    expect(@decorator.formatted_candidate_number("10")).to eq "  10"
    expect(@decorator.formatted_candidate_number("100")).to eq " 100"
    expect(@decorator.formatted_candidate_number("1000")).to eq "1000"
  end

  it 'formats proportional number' do
    precision = Vaalit::Voting::PROPORTIONAL_PRECISION
    expect(@decorator.formatted_proportional_number(nil)).to eq("    0." + "0" * precision)
    expect(@decorator.formatted_proportional_number(0.0)).to eq("    0." + "0" * precision)
    expect(@decorator.formatted_proportional_number(1.123)).to eq("    1.123" + "0" * (precision-3))
    expect(@decorator.formatted_proportional_number(1)).to eq("    1." + "0" * precision)
    expect(@decorator.formatted_proportional_number(10)).to eq("   10." + "0" * precision)
    expect(@decorator.formatted_proportional_number(100)).to eq("  100." + "0" * precision)
    expect(@decorator.formatted_proportional_number(1000)).to eq(" 1000." + "0" * precision)
    expect(@decorator.formatted_proportional_number(10000)).to eq("10000." + "0" * precision)
  end

  it 'formats vote sum' do
    expect(@decorator.formatted_vote_sum(nil)).to eq("     ")
    expect(@decorator.formatted_vote_sum(0)).to eq("    0")
    expect(@decorator.formatted_vote_sum(1)).to eq("    1")
    expect(@decorator.formatted_vote_sum(10)).to eq("   10")
    expect(@decorator.formatted_vote_sum(100)).to eq("  100")
    expect(@decorator.formatted_vote_sum(1000)).to eq(" 1000")
    expect(@decorator.formatted_vote_sum(10000)).to eq("10000")
  end

  it 'formats the elected candidates count' do
    expect(@decorator.formatted_elected_candidates_count(nil)).to eq " 0"
    expect(@decorator.formatted_elected_candidates_count(0)).to eq " 0"
    expect(@decorator.formatted_elected_candidates_count(10)).to eq "10"
  end

  it 'formats dots between coalition name and coalition shorten' do
    name = "Nimien Vaalirengas"
    shorten = "Nimet"
    dot_count = 66 - name.length - shorten.length

    expected = name + ('.' * dot_count) + shorten
    expect(@decorator.formatted_coalition_name_with_dots_and_shorten(name, shorten)).to eq expected
  end

  it 'formats dots after the candidate name' do
    max_count = 30

    expect(@decorator.formatted_candidate_name_with_dots("")).to eq("." * max_count)

    ["Short Name", "Li Ly", "Normalissimo Namimo 'Nickname'"].each do |name|
      expect(@decorator.formatted_candidate_name_with_dots(name))
        .to eq(name + "." * how_many_dots(name, max_count))
    end
  end

  it 'formats candidate name' do
    normal_name = "Mahtuu Rajoitteisiin 'Lemppri'"
    long_name   = "Ei Mahdu vaan on liian pitkä about nyt"
    expect(@decorator.formatted_candidate_name_with_dots(normal_name)).to eq normal_name
    expect(@decorator.formatted_candidate_name_with_dots(long_name)).to eq "Ei Mahdu vaan on liian pitkä a"
  end

  it 'formats election status character' do
    not_effective = not_elected = false
    effective = elected = true

    expect(@decorator.formatted_status_char(elected, not_effective, not_effective, not_effective)).to eq  "*"
    expect(@decorator.formatted_status_char(elected, not_effective, not_effective, effective)).to eq  "="
    expect(@decorator.formatted_status_char(elected, effective, effective, not_effective)).to eq "~"
    expect(@decorator.formatted_status_char(elected, effective, not_effective, not_effective)).to eq "?"
    expect(@decorator.formatted_status_char(elected, effective, effective, effective)).to eq "="
    expect(@decorator.formatted_status_char(not_elected, not_effective, not_effective, not_effective)).to eq  "."
    expect(@decorator.formatted_status_char(not_elected, not_effective, not_effective, effective)).to eq  "="
    expect(@decorator.formatted_status_char(not_elected, effective, effective, not_effective)).to eq  "~"
    expect(@decorator.formatted_status_char(not_elected, effective, not_effective, not_effective)).to eq  "?"
    expect(@decorator.formatted_status_char(not_elected, effective, effective, effective)).to eq  "="
  end

  def how_many_dots(name, max_count)
    count = max_count - name.length
    count = 0 if count < 0

    count
  end

end
