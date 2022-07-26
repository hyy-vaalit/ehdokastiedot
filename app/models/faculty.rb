class Faculty < ActiveRecord::Base
  has_many :candidates

  validates_presence_of :name, :code, :numeric_code
end
