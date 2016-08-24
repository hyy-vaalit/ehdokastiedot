class ResultDecorator < ApplicationDecorator
  decorates :result

  delegate_all

  def potential_voters
    GlobalConfiguration.potential_voters_count
  end

  def votes_given
    GlobalConfiguration.votes_given
  end

  def candidates_to_elect
    Vaalit::Voting::ELECTED_CANDIDATE_COUNT
  end

  def votes_counted
    vote_sum_cache
  end

  def votes_counted_percentage
    return 0 if votes_accepted.to_i == 0

    100.0 * votes_counted / votes_accepted
  end

  # If result is freezed (not going to be recalculated any more), then
  # the amount of all counted votes is the same amount of all accepted votes.
  # Otherwise all accepted votes is submitted manually during the Vaalivalvojaiset show.
  def votes_accepted
    if self.freezed?
      votes_counted
    else
      GlobalConfiguration.votes_accepted
    end
  end

  def voting_percentage
    return 0 if votes_given.to_i == 0

    100.0 * votes_given / potential_voters
  end

  def formatted_timestamp(timestamp_method, opts = {})
    time = opts[:time] == false ? "" : " klo %H:%M:%S"
    self.send(timestamp_method).localtime.strftime("%d.%m.%Y" + time)
  end

  def most_recent?
     id == Result.last.id
  end

  def result_file_url
    "#{Vaalit::Results::PUBLIC_RESULT_URL}/#{filename}"
  end

  def to_html
    av = ApplicationController.view_context_class.new(Rails.configuration.paths['app/views'])
    output = av.render :partial => "manage/results/result.html.erb", :locals => {:result_decorator => self}
  end

  def to_json
    av = ApplicationController.view_context_class.new(Rails.configuration.paths['app/views'])
    output = av.render :template => "manage/results/show.json", :locals => {:result => self}
  end

  # TODO: Refactor common parts to eg. #to_json(:candidates)
  def to_json_candidates
    av = ApplicationController.view_context_class.new(Rails.configuration.paths['app/views'])
    output = av.render :template => "manage/results/candidates.json", :locals => {:result => self}
  end

  # EHDOKKAAT___________________________NUM_LIITTO__ÄÄNET___LVERT________RVERT_____
  # 1* Sukunimi, Etunimi 'Lempinimi.... 788 Humani   55    696.00000   2901.00000
  def candidate_result_line(candidate, index)
    (formatted_order_number(index+1) +
    formatted_status_char(candidate.elected?,
                          candidate.candidate_draw_affects_elected?,
                          candidate.alliance_draw_affects_elected?,
                          candidate.coalition_draw_affects_elected?) + " " +
    formatted_candidate_name_with_dots(candidate.candidate_name) +
    formatted_candidate_number(candidate.candidate_number) + " " +
    formatted_alliance_shorten(candidate.electoral_alliance_shorten) +
    formatted_vote_sum(candidate.vote_sum) +
    formatted_draw_char(candidate.candidate_draw_identifier) +
    formatted_proportional_number(candidate.alliance_proportional) +
    formatted_draw_char(candidate.alliance_draw_identifier) +
    formatted_proportional_number(candidate.coalition_proportional) +
    formatted_draw_char(candidate.coalition_draw_identifier)).html_safe  # FIXME: Otherwise double quotes will mess output
  end

  #RENKAAT________________________________________________________________ÄÄNET_PA
  #  6. Svenska Nationer och Ämnesföreningar (SNÄf)...................SNÄf  555  3
  def coalition_result_line(coalition_result, index)
    formatted_order_number(index+1) + ". " +
    formatted_coalition_name_with_dots_and_shorten(coalition_result.electoral_coalition.name, coalition_result.electoral_coalition.shorten) +
    formatted_vote_sum(coalition_result.vote_sum_cache) + " " +
    formatted_elected_candidates_count(elected_candidates_in_coalition(coalition_result).count)
  end

  # LIITOT__________________________________________________________RENGAS_ÄÄNET_PA
  #  24. SatO-ESO2............................................SatESO Osak    181  1
  def alliance_result_line(alliance_result, index)
    formatted_order_number(index+1) + ". " +
    formatted_alliance_name_with_dots_and_shorten(alliance_result.electoral_alliance.name, alliance_result.electoral_alliance.shorten) + " " +
    formatted_coalition_shorten(alliance_result.electoral_alliance.electoral_coalition.shorten) +
    formatted_vote_sum(alliance_result.vote_sum_cache) + " " +
    formatted_elected_candidates_count(elected_candidates_in_alliance(alliance_result).count)
  end

  def formatted_order_number(number)
    sprintf "%3d", number
  end

  def formatted_draw_char(identifier)
    sprintf "%2.2s", identifier
  end

  def formatted_status_char(elected, effective_candidate_draw, effective_alliance_draw, effective_coalition_draw)
    if not final?
      return "=" if effective_coalition_draw
      return "~" if effective_alliance_draw
      return "?" if effective_candidate_draw
    end
    return "*" if elected
    return "."
  end

  def formatted_elected_candidates_count(number)
    sprintf "%2d", number.to_i
  end

  def formatted_candidate_number(number)
    sprintf "%4d", number.to_i
  end

  def fill_dots(line_width, *contents)
    content_length = contents.map(&:length).sum
    dot_count = line_width - content_length
    dot_count = 0 if dot_count < 0

    '.' * dot_count
  end

  def formatted_coalition_shorten(shorten)
    sprintf "%-6.6s", shorten
  end

  def formatted_alliance_name_with_dots_and_shorten(name, shorten)
    line_width = 58
    truncated_name = name.slice(0,52)
    truncated_shorten = shorten.slice(0,6)
    sprintf "%.52s%s.%.6s", truncated_name, fill_dots(line_width, truncated_name, truncated_shorten), truncated_shorten
  end

  def formatted_coalition_name_with_dots_and_shorten(name, shorten)
    line_width = 66
    truncated_shorten = shorten.slice(0,6)
    truncated_name = name.slice(0,52)
    sprintf "%.52s%s%.6s", truncated_name, fill_dots(line_width, truncated_name, truncated_shorten), truncated_shorten
  end

  def formatted_candidate_name_with_dots(candidate_name)
    line_width = 30
    truncated_name = candidate_name.slice(0,line_width)
    sprintf "%.#{line_width}s%s", truncated_name, fill_dots(line_width, truncated_name)
  end

  def formatted_alliance_shorten(shorten)
    sprintf "%6.6s", shorten
  end

  def formatted_vote_sum(number)
    sprintf "%5s", number
  end

  def formatted_proportional_number(number)
    precision = Vaalit::Voting::PROPORTIONAL_PRECISION
    sprintf "%11.#{precision}f", number.to_f
  end

end
