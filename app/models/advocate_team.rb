class AdvocateTeam < ActiveRecord::Base
  has_many :advocate_users, dependent: :nullify

  has_one :electoral_coalition, dependent: :nullify
  has_many :electoral_alliances, through: :electoral_coalition

  belongs_to :primary_advocate_user, class_name: "AdvocateUser"

  validates_presence_of :name, :primary_advocate_user_id

  validates_uniqueness_of :primary_advocate_user_id

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
