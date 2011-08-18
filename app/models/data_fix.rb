class DataFix < ActiveRecord::Base

  belongs_to :candidate

  scope :unapplied, where(:applied => false)
  scope :accepted, where(:applied => true, :status => true)
  scope :rejected, where(:applied => true, :status => false)

  def accept!
    candidate = self.candidate
    candidate.update_attribute self.field_name.to_sym, self.new_value
    self.update_attributes :applied => true, :status => true
  end

  def reject!
    self.update_attributes :applied => true, :status => false
  end

end
