class FinalResultJob

  def perform
    switch_proportionals_according_draws
    switch_coalition_proportionals_according_alliance_draws
  end

end
