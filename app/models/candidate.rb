class Candidate < ActiveRecord::Base
  include RankedModel

  ranks :sign_up_order, :with_same => :electoral_alliance_id

end
