class AllianceResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :electoral_alliance
end
