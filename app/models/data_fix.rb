class DataFix < ActiveRecord::Base

  belongs_to :candidate

  scope :unapplied, where(:applied => false)

  def apply!
    self.update_attribute :applied, true
  end

end
