class ElectoralAlliance < ActiveRecord::Base
  has_many :candidates, :dependent => :nullify

  belongs_to :advocate_user, :foreign_key => :primary_advocate_id
  belongs_to :electoral_coalition

  scope :without_advocate_user, -> { where(:primary_advocate_id => nil) }
  scope :without_coalition, -> { where(:electoral_coalition_id => nil) }
  scope :ready, -> { where(:secretarial_freeze => true) }
  scope :for_dashboard, -> { order("primary_advocate_id ASC") }
  scope :by_numbering_order, -> { order("#{table_name}.numbering_order") }

  validates_presence_of :name, :shorten
  validates_uniqueness_of :shorten, :name

  validates_length_of :shorten, :in => 2..6
  validates_presence_of :expected_candidate_count, :allow_nil => true

  before_save :strip_whitespace_from_name_fields

  def freeze!
    if expected_candidate_count && candidates.count == expected_candidate_count
      return self.update! secretarial_freeze: true
    else
      errors.add :expected_candidate_count, "does not match to actual candidate count"
      return false
    end
  end

  def has_all_candidates?
    candidates.count == expected_candidate_count
  end

  def self.are_all_ready?
    self.count == self.ready.count
  end

  protected

  def strip_whitespace_from_name_fields
    self.name.strip!
    self.shorten.strip!
  end
end
