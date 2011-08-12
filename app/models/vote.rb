class Vote < ActiveRecord::Base

  belongs_to :voting_area
  belongs_to :candidate

  validates_presence_of :voting_area, :candidate

  scope :ready, joins(:voting_area).where('voting_areas.taken = ?', true)

  default_scope :include => :candidate, :order => 'candidates.candidate_number'

end
