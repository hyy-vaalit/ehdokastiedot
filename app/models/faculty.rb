# FIXME: This model represents a department, not a faculty.
class Faculty < ActiveRecord::Base

  has_many :candidates

  validates_presence_of :name, :code
end
