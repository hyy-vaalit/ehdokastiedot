module ListingsHelper

  def show_state_char(candidate)
    if candidate.selected?
      '*'
    elsif candidate.spared?
      '+'
    else
      '.'
    end
  end

  def display_dots_after_candidate_name(candidate)
    name = candidate.candidate_name.gsub ',', ''
    total_space = 30
    dot_count = total_space - name.length
    sprintf "%s%s", name, '.'*dot_count
  end

  def display_dots_between_name_and_shorten(total_space, org)
    shorten = org.shorten || ''
    max_name_length = total_space - (shorten.length + 1)
    name = org.name[0..max_name_length]
    dot_count = total_space - (name.length + shorten.length)
    sprintf "%s%s%s", name, '.'*dot_count, shorten
  end

end
