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

end
