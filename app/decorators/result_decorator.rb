class ResultDecorator < ApplicationDecorator
  decorates :result

  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by calling this method:
  #     lazy_helpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end

  def formatted_created_at
    created_at.strftime("%Y-%m-%d klo %H:%M:%S")
  end

  def most_recent?
     id == Result.last.id
  end

  def result_file_url
    "#{Vaalit::Results::S3_BUCKET_URL}/#{filename}"
  end

  def rendered_output
    # DEPRECATION WARNING: config.view_path is deprecated, please do paths.app.views instead.
    av = ApplicationController.view_context_class.new(Rails.configuration.view_path)
    output = av.render :partial => "results/result.text.erb", :locals => {:result_decorator => self}

  end

  # EHDOKKAAT___________________________NUM_LIITTO__ÄÄNET___LVERT________RVERT_____
  # 1* Sukunimi, Etunimi 'Lempinimi.... 788 Humani   55    696.00000   2901.00000
  def candidate_result_line(candidate, index)
    formatted_order_number(index+1) +
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
    formatted_draw_char(candidate.coalition_draw_identifier)
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
    return "=" if effective_coalition_draw
    return "~" if effective_alliance_draw
    return "?" if effective_candidate_draw
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

    sprintf "%.52s%s.%.6s", name, fill_dots(line_width, name, shorten), shorten
  end

  def formatted_coalition_name_with_dots_and_shorten(name, shorten)
    line_width = 66

    sprintf "%.52s%s%.6s", name, fill_dots(line_width, name, shorten), shorten
  end

  def formatted_candidate_name_with_dots(candidate_name)
    line_width = 30
    sprintf "%.#{line_width}s%s", candidate_name, fill_dots(line_width, candidate_name)
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