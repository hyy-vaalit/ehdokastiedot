class Candidate < ActiveRecord::Base
  include RankedModel

  # Rank valid Candidates in the same ElectoralAlliance.
  # The scope MUST match with the scope defined in `scope :by_numbering_order` in order to
  # present correct position numbers in the UI.
  ranks :numbering_order,
    with_same: :electoral_alliance_id,
    scope: :valid

  has_many :candidate_attribute_changes

  belongs_to :electoral_alliance
  has_one :electoral_coalition, :through => :electoral_alliance

  belongs_to :faculty, optional: true

  scope :cancelled, -> { where(:cancelled => true).order("cancelled_at desc") }
  scope :valid, -> { where(:cancelled => false) }
  scope :without_alliance, -> { where(:electoral_alliance_id => nil) }

  # by_numbering_order is the order in which candidate numbers will be assigned.
  # Cancelled candidates are not included in the result.
  # This scope MUST match with the scope defined in `ranks :numbering_order`.
  scope :by_numbering_order, -> { valid.reorder("#{table_name}.numbering_order") }

  # by_candidate_number can be used after candidate numbers have been assigned.
  # Until that point candidate numbers are blank and by_numbering_order should be used instead.
  #
  # by_candidate_number does not contain cancelled candidates because they won't have a candidate
  # number.
  scope :by_candidate_number, -> { reorder("#{table_name}.candidate_number") }

  # Before 2022, the validation was intentionally loose with the paper registration form.
  # However, the validation can now be reasonably stricter since the candidacy form is nowdays
  # filled electronically by the candidate.
  validates_presence_of :lastname,
    :firstname,
    :candidate_name,
    :email,
    :student_number,
    :electoral_alliance

  validates_format_of :candidate_name, :with => /\A(.+), (.+)\Z/, # Lastname, Firstname Whatever Here 'this' or "this"
                                       :message => "Ehdokasnimen on oltava muotoa Sukunimi, Etunimi, ks. ohje."

  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  validate :unique_non_cancelled_student_number

  before_save :clear_linebreaks_from_notes!
  before_save :strip_whitespace!
  before_save :clear_cancelled_at, if: ->{ !cancelled }

  # If candidate numbers have been given, order by candidate numbers.
  # Otherwise order by alliance id and numbering order.
  def self.for_listing
    candidate_numbers_given? ? reorder('candidate_number') : reorder('electoral_alliance_id, numbering_order')
  end

  def self.candidate_numbers_given?
    first && valid.where(:candidate_number => nil).empty?
  end

  def cancel
    log_and_update_attributes(
      cancelled: true,
      cancelled_at: Time.now.getutc
    )
  end

  def self.can_give_numbers?
    ElectoralAlliance.are_all_ready? &&
      ElectoralCoalition.are_all_ordered? &&
      Candidate.without_alliance.empty? &&
      ElectoralAlliance.without_coalition.empty?
  end

  def self.give_numbers!
    return false unless can_give_numbers?

    Candidate.transaction do
      Candidate.update_all :candidate_number => 0

      candidates_in_order = Candidate
        .select('candidates.*')
        .joins(:electoral_alliance)
        .joins(:electoral_alliance => :electoral_coalition)
        .reorder("electoral_coalitions.numbering_order, electoral_alliances.numbering_order, candidates.numbering_order")
        .valid
        .all

      candidates_in_order.each.with_index(2) do |candidate, i|
        candidate.update_attribute :candidate_number, i
      end
    end

    return true
  end

  def log_and_update_attributes(attrs)
    Candidate.transaction do
      self.assign_attributes(attrs)
      CandidateAttributeChange.create_from!(self.id, self.changes) if self.changed? and GlobalConfiguration.log_candidate_attribute_changes?
      self.save
    end
  end

  protected

  def unique_non_cancelled_student_number
    if !cancelled
      another = Candidate
        .valid
        .where.not(id: id)
        .where(student_number: student_number)
        .present?

      if another
        errors.add :cancelled, "a non-cancelled candidate for student number #{student_number} already exists."
      end
    end
  end

  def clear_linebreaks_from_notes!
    self.notes = self.notes.gsub(/(\r\n|\n|\r)/, ', ') if self.notes
  end

  def strip_whitespace!
    self.email.strip!
    self.candidate_name.strip!
    self.firstname.strip!
    self.lastname.strip!
    self.student_number.strip!
    self&.address&.strip!
    self&.postal_code&.strip!
    self&.postal_city&.strip!
    self&.phone_number&.strip!
  end

  def clear_cancelled_at
    self.cancelled_at = nil
  end
end
