class Advocate < ActiveRecord::Base

  has_one :primary_nominated, :class_name => 'ElectoralAlliance', :foreign_key => :primary_advocate_id
  has_one :secondary_nominated, :class_name => 'ElectoralAlliance', :foreign_key => :secondary_advocate_id

  def nominated
    self.primary_nominated or self.secondary_nominated
  end

  def name
    "#{self.lastname} #{self.firstname}"
  end

end
