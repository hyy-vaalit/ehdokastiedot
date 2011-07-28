class Vote < ActiveRecord::Base

  belongs_to :voting_area
  belongs_to :candidate

  validates_presence_of :voting_area, :candidate

  default_scope :include => :candidate, :order => 'candidates.candidate_number'

end
