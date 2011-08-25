class AllianceDraw < ActiveRecord::Base

  has_many :alliance_drawings
  has_many :electoral_alliances, :through => :alliance_drawings

end
