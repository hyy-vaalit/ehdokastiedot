require 'csv'

class ElectoralAllianceDecorator < ApplicationDecorator
  decorates :electoral_alliance

  delegate_all

  def to_csv
    CandidateDecorator.to_csv(candidates)
  end
end
