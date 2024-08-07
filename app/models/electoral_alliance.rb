class ElectoralAlliance < ActiveRecord::Base
  attribute :invite_code, :string, default: -> { default_invite_code }
  validates_length_of :invite_code, minimum: 4
  validates_format_of :invite_code,
    with: /\A[A-Za-z0-9-]+\z/,
    message: "allows only English alphanumeric and - characters"

  has_many :candidates, :dependent => :nullify

  # Each Candidate needs to be accepted to the Alliance by its AdvocateUser.
  has_many :accepted_candidates, -> {
    where(alliance_accepted: true, cancelled: false)
  }, class_name: "Candidate"

  has_many :incoming_candidates, -> {
    where(alliance_accepted: false, cancelled: false)
  }, class_name: "Candidate"

  belongs_to :advocate_user, :foreign_key => :primary_advocate_id, optional: true
  belongs_to :electoral_coalition, optional: true

  scope :without_advocate_user, -> { where(:primary_advocate_id => nil) }
  scope :without_coalition, -> { where(:electoral_coalition_id => nil) }
  scope :ready, -> { where(:secretarial_freeze => true) }
  scope :for_dashboard, -> { order("primary_advocate_id ASC") }
  scope :by_coalition_id, -> { order("electoral_coalition_id") }
  scope :by_numbering_order, -> { order("#{table_name}.numbering_order") }

  validates_presence_of :name, :shorten, :invite_code
  validates_uniqueness_of :shorten, :name, :invite_code

  validates_length_of :shorten, :in => 2..6
  validates_presence_of :expected_candidate_count, :allow_nil => true
  validates :expected_candidate_count, numericality: { only_integer: true, in: 1..60 }

  before_validation :strip_whitespace_from_name_fields!
  before_validation :upcase_invite_code!

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

  def freeze!
    if has_all_candidates?
      return self.update! secretarial_freeze: true
    else
      errors.add :expected_candidate_count, "does not match to accepted candidate count"
      return false
    end
  end

  def has_all_candidates?
    expected_candidate_count > 0 && accepted_candidates.count == expected_candidate_count
  end

  def to_csv(encoding)
    CandidateExport.new(candidates).to_csv(encoding: encoding)
  end

  def self.are_all_ready?
    self.count == self.ready.count
  end

  protected

  def strip_whitespace_from_name_fields!
    self.name.strip!
    self.shorten.strip!
  end

  def upcase_invite_code!
    self.invite_code.upcase!
  end

  def self.default_invite_code
    Devise.friendly_token[0,4].upcase
  end
end
