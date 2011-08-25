class CoalitionDrawing < ActiveRecord::Base
  include RankedModel

  belongs_to :coalition_draw
  belongs_to :electoral_coalition

  ranks :position_in_draw, :with_same => :coalition_draw_id

end
