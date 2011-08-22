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

  def display_dots_after_name(candidate)
    name = candidate.candidate_name.gsub ',', ''
    total_space = 30
    dot_count = total_space - name.length
    sprintf "%s%s", name, '.'*dot_count
  end

end
