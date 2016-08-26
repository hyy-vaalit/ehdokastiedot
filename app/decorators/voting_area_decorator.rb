class VotingAreaDecorator < ApplicationDecorator
  decorates :voting_area

  delegate_all

  def state_class
    return "ready" if self.ready?
    return "submitted" if self.submitted?
    return "unfinished"
  end

  def formatted_state(state)
    return "X" if state
    return ""
  end

  def markable_ready?
    submitted? and not ready?
  end

end
