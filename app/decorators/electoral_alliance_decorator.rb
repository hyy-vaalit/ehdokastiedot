class ElectoralAllianceDecorator < ApplicationDecorator
  decorates :electoral_alliance

  delegate_all

  def to_csv(encoding)
    CandidateExport.new(candidates).to_csv(encoding: encoding)
  end
end
