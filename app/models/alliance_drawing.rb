class AllianceDrawing < ActiveRecord::Base
  include RankedModel

  belongs_to :alliance_draw
  belongs_to :electoral_alliance

  ranks :position_in_draw

end
