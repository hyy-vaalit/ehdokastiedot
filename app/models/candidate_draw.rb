class CandidateDraw < ActiveRecord::Base

  has_many :candidate_drawings
  has_many :candidates, :through => :candidate_drawings

end
