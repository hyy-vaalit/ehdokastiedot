class AllianceDraw < ActiveRecord::Base
  has_many :candidate_results
  belongs_to :result
end
