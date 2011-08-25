class CandidateDrawing < ActiveRecord::Base
  include RankedModel

  belongs_to :candidate_draw
  belongs_to :candidate

  ranks :position_in_draw

end
