class Candidate < ActiveRecord::Base
  include RankedModel
  include VotableBehaviour

  state_machine :initial => :not_selected do
    event :select_me do
      transition [:not_selected] => :selected
    end
    event :spare_me do
      transition [:not_selected] => :spared
    end
    event :unselect_me do
      transition any => :not_selected
    end
  end

  state_machine :final_state, :initial => :not_selected_at_all do
    event :select_me_at_last do
      transition [:not_selected_at_all] => :selected_at_last
    end
    event :spare_me_at_last do
      transition [:not_selected_at_all] => :spared_at_last
    end
    event :unselect_me_at_last do
      transition any => :not_selected_at_all
    end
  end

  has_many :coalition_proportionals
  has_many :alliance_proportionals
  has_many :candidate_results

  has_many :candidate_drawings
  has_many :candidate_draws, :through => :candidate_drawings

  belongs_to :electoral_alliance
  has_one :electoral_coalition, :through => :electoral_alliance

  ranks :sign_up_order, :with_same => :electoral_alliance_id

  belongs_to :faculty

  has_many :data_fixes

  scope :cancelled, where(:cancelled => true)

  scope :valid, where(:cancelled => false, :marked_invalid => false)

  scope :without_electoral_alliance, joins(:electoral_alliance).where('candidates.candidate_name = electoral_alliances.name')

  # Operator '&' is an intersection, ie, it matches only entities which are present in both groups.
  scope :has_fixes, lambda { joins(:data_fixes).select("distinct candidates.id, candidates.*") & DataFix.unapplied }

  scope :by_alliance, order('electoral_alliance_id desc')

  scope :selected, where(state: :selected)
  scope :selected_at_last, where(final_state: :selected_at_last)

  scope :from_coalition, lambda { |coalition|
    alliance_ids = coalition.electoral_alliance_ids
    where('candidates.electoral_alliance_id in (?)', alliance_ids)
  }

  validates_presence_of :lastname, :electoral_alliance

  before_save :clear_lines!

  attr_accessor :has_fixes

  def self.by_vote_sum
    select('candidates.id, sum(votes.amount) as vote_sum').from(
      'candidates, votes, voting_areas').where(
      'votes.candidate_id = candidates.id
         and voting_areas.ready = true
         and votes.voting_area_id = voting_areas.id').group(
      'candidates.id').order(
      'vote_sum desc')
  end

  def self.by_alliance_proportional(result)
    select('"candidates".id, "alliance_proportionals".number, "alliance_proportionals".number as alliance_proportional').from(
      '"candidates"').joins(
      'left join "alliance_proportionals" ON "candidates".id = alliance_proportionals.candidate_id').joins(
      'left join "results" ON "results".id = "alliance_proportionals".result_id').where([
      'results.id = ?', result.id]).order(
      '"alliance_proportionals".number desc')
  end

  def self.by_coalition_proportional
    select('"candidates".id,
            "coalition_proportionals".number,
            "coalition_proportionals".number as coalition_proportional').from(
      '"candidates"').joins(
      'inner join "coalition_proportionals" ON "candidates".id = coalition_proportionals.candidate_id').order(
      '"coalition_proportionals".number desc')
  end

  def self.includes_vote_sum
    select('SUM("votes"."amount") AS vote_sum').joins(
      'INNER JOIN "votes" ON "votes"."candidate_id" = "candidates"."id"').joins(
      'INNER JOIN "voting_areas" ON "voting_areas"."id" = "votes"."voting_area_id"').where(
      ['voting_areas.ready = ?', true]).group("candidates.id")
  end

  def self.by_cached_vote_sum
    select('candidates.id, candidates.candidate_name, candidates.candidate_number,
            SUM(candidate_results.vote_sum_cache) as vote_sum_cache').joins(
      'INNER JOIN candidate_results ON candidate_results.candidate_id = candidates.id').group(
      'candidates.id, candidates.candidate_name, candidates.candidate_number').order(
      'SUM(candidate_results.vote_sum_cache) desc')
  end

  def invalid!
    self.update_attribute :marked_invalid, true
  end

  def cancel!
    self.update_attribute :cancelled, true
  end

  def fixed_total_votes
    self.votes.fixed.sum(:vote_count)
  end

  def has_fixes
    self.data_fixes.count > 0
  end

  def vote_count_from_area(voting_area_id)
    voting_area = VotingArea.find_by_id voting_area_id
    vote = voting_area.votes.find_by_candidate_id self.id
    vote ? vote.vote_count : 0
  end

  def fix_vote_count_from_area(voting_area_id)
    voting_area = VotingArea.find_by_id voting_area_id
    vote = voting_area.votes.find_by_candidate_id self.id
    vote ? vote.fix_count : ''
  end

  def position_in_coalition
    Candidate.from_coalition(self.electoral_alliance.electoral_coalition).selection_order.index self
  end

  def self.final_order
    draws = CoalitionDraw.all
    self.selection_order.sort do |x,y|
      order_int = y.coalition_proportional <=> x.coalition_proportional
      if order_int == 0
        draw = draws.select{|d| d.include_candidate? x and d.include_candidate? y}.first
        if draw
          candidates = draw.candidates
          x_index = candidates.index x
          y_index = candidates.index y
          order_int = x_index <=> y_index
        else
          puts 'BUG' #FIXME: deprecated after 17873117 is fixed
        end
      end
      order_int
    end
  end

  def self.give_numbers!
    raise 'not ready' unless ElectoralAlliance.are_all_ready? and ElectoralCoalition.are_all_ordered?
    Candidate.transaction do
      Candidate.update_all :candidate_number => 0
      candidates_in_order = Candidate.select('candidates.*').joins(:electoral_alliance).joins(:electoral_alliance => :electoral_coalition).order(:number_order).order(:signing_order).order(:sign_up_order).valid.all
      candidates_in_order.each_with_index do |candidate, i|
        candidate.update_attribute :candidate_number, i+2
      end
    end
  end

  def clear_lines!
    self.notes.gsub!(/(\r\n|\n|\r)/, ', ') if self.notes
  end

end
