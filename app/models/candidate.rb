class Candidate < ActiveRecord::Base
  include RankedModel

  belongs_to :electoral_alliance
  ranks :sign_up_order, :with_same => :electoral_alliance_id

  belongs_to :faculty

  has_many :data_fixes

  has_many :votes

  scope :cancelled, where(:cancelled => true)

  scope :valid, where(:cancelled => false, :marked_invalid => false)

  def invalid!
    self.update_attribute :marked_invalid, true
  end

  def cancel!
    self.update_attribute :cancelled, true
  end

  def total_votes
    self.votes.ready.sum(:vote_count)
  end

  def self.give_numbers!
    ordered_candidates = []
    all_valid_candidates = Candidate.valid.order(:candidate_name).all
    coalitions = ElectoralCoalition.order(:number_order).all
    coalitions.each do |coalition|
      coalition.electoral_alliances.rank(:signing_order).each do |alliance|
        alliance.candidates.valid.rank(:sign_up_order).each do |candidate|
          ordered_candidates << candidate
          all_valid_candidates.delete(candidate)
        end
      end
    end
    ordered_candidates.concat(all_valid_candidates)
    ordered_candidates.each_with_index do |candidate, i|
      candidate.update_attribute :candidate_number, i+2
    end
  end

end
