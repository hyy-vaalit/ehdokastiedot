class FinalResultJob

  def perform
    CandidateRearrange.switch_proportionals_according_draws
    CandidateRearrange.switch_coalition_proportionals_according_alliance_draws
    Proportionals.final_position!
    ResultPage.render_final_results
  end

end
