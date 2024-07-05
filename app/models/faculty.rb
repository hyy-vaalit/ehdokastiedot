class Faculty < ActiveRecord::Base
  has_many :candidates

  validates_presence_of :name, :code, :numeric_code

  # Attributes searchable in ActiveAdmin
  def self.ransackable_attributes(_auth_object = nil)
    # allow all
    authorizable_ransackable_attributes
  end

  # Associations searchable in ActiveAdmin
  def self.ransackable_associations(_auth_object = nil)
    # allow all
    authorizable_ransackable_associations
  end
end
