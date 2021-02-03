class Candidate < ActiveRecord::Base
  include RankedModel

  has_many :candidate_attribute_changes

  belongs_to :electoral_alliance
  has_one :electoral_coalition, :through => :electoral_alliance

  ranks :numbering_order, :with_same => :electoral_alliance_id

  belongs_to :faculty

  scope :cancelled, -> { where(:cancelled => true) }
  scope :without_alliance, -> { where(:electoral_alliance_id => nil) }
  scope :valid, -> { where(:cancelled => false, :marked_invalid => false) }
  scope :votable, -> {  where(:cancelled => false, :marked_invalid => false) }
  scope :by_numbering_order, -> {  order("#{table_name}.numbering_order") }

  # Advocate must be able to fill candidate information which lacks of information.
  # The information may not be available even in the paper form, but it can be
  # submitted later. Validation must not be too strict!
  validates_presence_of :lastname, :electoral_alliance

  validates_format_of :candidate_name, :with => /\A(.+), (.+)\Z/, # Lastname, Firstname Whatever Here 'this' or "this"
                                       :message => "Ehdokasnimen on oltava muotoa Sukunimi, Etunimi, ks. ohje."

  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  before_save :clear_linebreaks_from_notes,
              :strip_whitespace_from_name_fields

  # If candidate numbers have been given, order by candidate numbers.
  # Otherwise order by alliance id and numbering order.
  def self.for_listing
    candidate_numbers_given? ? reorder('candidate_number') : reorder('electoral_alliance_id, numbering_order')
  end

  def self.candidate_numbers_given?
    first && where(:candidate_number => nil).empty?
  end

  def invalid!
    self.update_attribute :marked_invalid, true
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
      candidates_in_order = Candidate.select('candidates.*').joins(:electoral_alliance).joins(:electoral_alliance => :electoral_coalition).reorder(
        "electoral_coalitions.numbering_order, electoral_alliances.numbering_order, candidates.numbering_order").valid.all
      candidates_in_order.each_with_index do |candidate, i|
        candidate.update_attribute :candidate_number, i+2
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

  def clear_linebreaks_from_notes
    self.notes = self.notes.gsub(/(\r\n|\n|\r)/, ', ') if self.notes
  end

  def strip_whitespace_from_name_fields
    self.candidate_name.strip!
    self.firstname.strip!
    self.lastname.strip!
  end

end
