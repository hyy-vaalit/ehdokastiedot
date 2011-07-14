class ElectoralAlliance < ActiveRecord::Base
  include RankedModel

  ranks :signing_order, :with_same => :electoral_circle_id

end
