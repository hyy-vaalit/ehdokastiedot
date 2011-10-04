class CandidateResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :candidate
end
