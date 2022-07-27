class Candidate < ActiveRecord::Base
  include RankedModel
  ranks :numbering_order, :with_same => :electoral_alliance_id

  has_many :candidate_attribute_changes

  belongs_to :electoral_alliance
  has_one :electoral_coalition, :through => :electoral_alliance

  belongs_to :faculty, optional: true

  scope :cancelled, -> { where(:cancelled => true) }
  scope :valid, -> { where(:cancelled => false) }
  scope :without_alliance, -> { where(:electoral_alliance_id => nil) }
  scope :by_numbering_order, -> {  order("#{table_name}.numbering_order") }
  scope :by_candidate_number, -> { order("#{table_name}.candidate_number") }

  # Before 2022, the validation was intentionally loose with the paper registration form.
  # However, the validation can now be reasonably stricter since the candidacy form is nowdays
  # filled electronically by the candidate.
  validates_presence_of :lastname,
    :firstname,
    :candidate_name,
    :email,
    :student_number,
    :electoral_alliance,
    :cancelled,
    :numbering_order

  validates_format_of :candidate_name, :with => /\A(.+), (.+)\Z/, # Lastname, Firstname Whatever Here 'this' or "this"
                                       :message => "Ehdokasnimen on oltava muotoa Sukunimi, Etunimi, ks. ohje."

  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  before_save :clear_linebreaks_from_notes!
  before_save :strip_whitespace!

  # If candidate numbers have been given, order by candidate numbers.
  # Otherwise order by alliance id and numbering order.
  def self.for_listing
    candidate_numbers_given? ? reorder('candidate_number') : reorder('electoral_alliance_id, numbering_order')
  end

  def self.candidate_numbers_given?
    first && valid.where(:candidate_number => nil).empty?
  end

  def cancel!
    self.update_attribute :cancelled, true
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
      self.attributes = attrs
      CandidateAttributeChange.create_from!(self.id, self.changes) if self.changed? and GlobalConfiguration.log_candidate_attribute_changes?
      self.save
    end
  end

  protected

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

end
