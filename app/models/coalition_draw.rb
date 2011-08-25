class CoalitionDraw < ActiveRecord::Base

  has_many :coalition_drawings
  has_many :electoral_coalitions, :through => :coalition_drawings

end
