class DrawArrangeJob

  def perform
    REDIS.set('drawing_status', 'initializing')
    Proportionals.fixed_calculus!
    CoalitionDraw.check_between_coalitions
    AllianceDraw.check_between_alliances
    CandidateDraw.check_inside_alliances
    REDIS.set('drawing_status', 'ready')
  end

end
