class Vote < ActiveRecord::Base

  belongs_to :voting_area
  belongs_to :candidate

end
