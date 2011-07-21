class DataFix < ActiveRecord::Base

  belongs_to :candidate

  scope :unapplied, where(:applied => false)

end
