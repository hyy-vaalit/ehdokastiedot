class ElectoralAlliance < ActiveRecord::Base
  include RankedModel

  has_many :candidates

  belongs_to :electoral_coalition
  ranks :signing_order, :with_same => :electoral_circle_id

  # Advocates
  belongs_to :primary_advocate, :class_name => 'Advocate'
  belongs_to :secondary_advocate, :class_name => 'Advocate'

end
