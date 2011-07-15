class ElectoralAlliance < ActiveRecord::Base
  include RankedModel

  has_many :candidates

  belongs_to :electoral_coalition
  ranks :signing_order, :with_same => :electoral_coalition_id

end
