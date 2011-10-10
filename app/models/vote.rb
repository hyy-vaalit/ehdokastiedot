class Vote < ActiveRecord::Base

  belongs_to :voting_area
  belongs_to :candidate

  validates_presence_of :voting_area, :candidate, :amount
  validate :must_have_positive_amount

  scope :countable, joins(:voting_area).where('voting_areas.ready = ?', true)

  scope :fixed, from("(SELECT COALESCE(v.fix_count, v.vote_count) as vote_count, v.id, v.candidate_id, v.voting_area_id, v.created_at, v.updated_at, v.fix_count FROM votes v) votes")

  scope :with_fixes, where('fixed_amount is not null')

  default_scope :include => :candidate, :order => 'candidates.candidate_number'

  def self.final
    select('COALESCE(votes.fixed_amount, votes.amount) as final_vote_amount,
           votes.id, votes.candidate_id, votes.voting_area_id')
  end

  def self.create_or_update_from(voting_area_id, candidate_id, vote_amount, fixed_amount)
    amount_attribute = fixed_amount ? :fixed_amount : :amount
    existing_vote = self.where("voting_area_id = ? AND candidate_id = ?", voting_area_id, candidate_id).first

    if existing_vote
      return existing_vote.update_attributes(amount_attribute.to_sym => vote_amount)
    else
      return self.create(:candidate_id => candidate_id, amount_attribute.to_sym => vote_amount, :voting_area_id => voting_area_id)
    end
  end

  def self.calculated
    votes_ready = self.ready.sum(:vote_count)
    if votes_ready == self.sum(:vote_count)
      100
    else
      total_votes = REDIS.get('total_vote_count')
      if total_votes
        (100 * votes_ready / total_votes.to_i).to_i
      else
        0
      end
    end
  end

  protected

  def must_have_positive_amount
    errors.add :base, "Must have positive vote amount" if (amount and amount < 0) or (fixed_amount and fixed_amount < 0)
  end
end
