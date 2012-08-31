class Candidate < ActiveRecord::Base
  include RankedModel

  default_scope order(:numbering_order)

  attr_accessible :lastname, :firstname, :social_security_number, :phone_number,
                  :faculty_id, :address, :postal_information, :email,
                  :candidate_name, :notes, :numbering_order_position,
                  :active_admin_hack_alliance_id # See comments in Admin::Candidates

  attr_accessor :active_admin_hack_alliance_id # See comments in Admin::Candidates

  has_many :votes do
    def preliminary_sum
      countable.sum("amount")
    end
  end

  has_many :coalition_proportionals
  has_many :alliance_proportionals
  has_many :candidate_results

  has_many :candidate_drawings
  has_many :candidate_draws, :through => :candidate_drawings

  has_many :candidate_attribute_changes

  belongs_to :electoral_alliance
  has_one :electoral_coalition, :through => :electoral_alliance

  ranks :numbering_order, :with_same => :electoral_alliance_id

  belongs_to :faculty

  has_many :data_fixes

  scope :cancelled, where(:cancelled => true)
  scope :without_alliance, where(:electoral_alliance_id => nil)
  scope :valid, where(:cancelled => false, :marked_invalid => false)

  # Operator '&' is an intersection, ie, it matches only entities which are present in both groups.
  # DEPRECATION WARNING: Using & to merge relations has been deprecated and will be removed in Rails 3.1. Please use the relation's merge method, instead.
  scope :has_fixes, lambda { joins(:data_fixes).select("distinct candidates.id, candidates.*") & DataFix.unapplied }

  scope :by_alliance, order('electoral_alliance_id desc')
  scope :votable, where(:cancelled => false, :marked_invalid => false)

  # Advocate must be able to fill candidate information which lacks of information.
  # The information may not be available even in the paper form, but it can be
  # submitted later. Validation must not be too strict!
  validates_presence_of :lastname, :electoral_alliance

  validates_format_of :candidate_name, :with => /\A(.+), (.+)\Z/, # Lastname, Firstname Whatever Here 'this' or "this"
                                       :message => "Ehdokasnimen on oltava muotoa Sukunimi, Etunimi, ks. ohje."

  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  before_save :clear_lines!

  attr_accessor :has_fixes

  # Calculates all votes from all 'ready' (calculable) voting areas for each candidate.
  # If there exists a fixed vote amount, it will be used instead of the preliminary amount.
  def self.with_vote_sums_for(result)
    votable.select('candidates.id, SUM(COALESCE(votes.fixed_amount, votes.amount, 0)) as vote_sum').joins(
     'LEFT JOIN  votes                 ON votes.candidate_id = candidates.id').joins(
     'LEFT JOIN  candidate_results     ON candidate_results.candidate_id = candidates.id').joins(
     'LEFT JOIN  voting_areas          ON voting_areas.id = votes.voting_area_id').where(
      '(votes.candidate_id = candidates.id OR votes.candidate_id IS NULL)
         AND (voting_areas.ready = ?                 OR voting_areas.ready IS NULL)
         AND (candidate_results.result_id = ?        OR candidate_results.result_id IS NULL)
         AND (votes.voting_area_id = voting_areas.id OR votes.voting_area_id IS NULL)', true, result.id).group(
      'candidates.id, candidate_results.candidate_draw_order').order(
      'vote_sum desc, candidate_results.candidate_draw_order asc')
  end

  def self.with_vote_sums
    votable.select('candidates.id, SUM(COALESCE(votes.fixed_amount, votes.amount, 0)) as vote_sum').joins(
      'LEFT JOIN "votes" ON "votes"."candidate_id" = "candidates"."id"').joins(
      'LEFT JOIN "voting_areas" ON "voting_areas"."id" = "votes"."voting_area_id"').where(
      'voting_areas.ready = ? OR voting_areas.ready IS NULL', true).group("candidates.id").order(
      'vote_sum desc')
  end

  def self.with_alliance_proportionals_for(result)
    select('"candidates".id, "alliance_proportionals".number, "alliance_proportionals".number as alliance_proportional').from(
      '"candidates"').joins(
      'INNER JOIN alliance_proportionals ON candidates.id = alliance_proportionals.candidate_id').joins(
      'INNER JOIN candidate_results      ON candidate_results.candidate_id = candidates.id').joins(
      'INNER JOIN results                ON results.id = alliance_proportionals.result_id').where([
      'results.id = ? AND candidate_results.result_id = ?', result.id, result.id]).order(
      '"alliance_proportionals".number desc, candidate_results.alliance_draw_order asc')
  end

  def self.by_cached_vote_sum
    select('candidates.id, candidates.candidate_name, candidates.candidate_number,
            SUM(candidate_results.vote_sum_cache) as vote_sum_cache').joins(
      'INNER JOIN candidate_results ON candidate_results.candidate_id = candidates.id').group(
      'candidates.id, candidates.candidate_name, candidates.candidate_number').order(
      'SUM(candidate_results.vote_sum_cache) desc')
  end

  def self.with_votes_in_voting_area(voting_area_id)
    select('candidates.id, candidates.candidate_number, votes.amount AS vote_amount, votes.fixed_amount AS fixed_vote_amount').joins(
      'INNER JOIN "votes" ON "votes"."candidate_id" = "candidates"."id"').joins(
      'INNER JOIN "voting_areas" ON "voting_areas"."id" = "votes"."voting_area_id"').where(
      ['voting_areas.id = ?', voting_area_id]).order('candidates.candidate_number asc')
  end

  def self.for_checking_minutes(voting_area_id)
   with_votes_in_voting_area(voting_area_id).select(
     'electoral_alliances.shorten as electoral_alliance_shorten').joins(
     'inner join "electoral_alliances" ON "candidates".electoral_alliance_id = electoral_alliances.id')
  end

  def self.for_checking_minutes_only_fixed_votes(voting_area_id)
    for_checking_minutes(voting_area_id).where("votes.fixed_amount is not null")
  end

  def invalid!
    self.update_attribute :marked_invalid, true
  end

  def cancel!
    self.update_attribute :cancelled, true
  end

  def has_fixes
    self.data_fixes.count > 0
  end

  def self.give_numbers!
    return false unless ElectoralAlliance.are_all_ready? and ElectoralCoalition.are_all_ordered?

    Candidate.transaction do
      Candidate.update_all :candidate_number => 0
      candidates_in_order = Candidate.select('candidates.*').joins(:electoral_alliance).joins(:electoral_alliance => :electoral_coalition).order(
        "electoral_coalitions.numbering_order, electoral_alliances.numbering_order, candidates.numbering_order").valid.all
      candidates_in_order.each_with_index do |candidate, i|
        candidate.update_attribute :candidate_number, i+2
      end
    end

    return true
  end

  def clear_lines!
    self.notes.gsub!(/(\r\n|\n|\r)/, ', ') if self.notes
  end

  def log_and_update_attributes(attrs)
    Candidate.transaction do
      self.attributes = attrs
      CandidateAttributeChange.create_from!(self.id, self.changes) if self.changed? and GlobalConfiguration.log_candidate_attribute_changes?
      self.save
    end
  end
end
