class ElectoralAlliance < ActiveRecord::Base
  include RankedModel

  has_many :votes, :through => :candidates do
    def preliminary_sum
      countable.sum("amount")
    end

    def countable_sum
      countable.sum("COALESCE(votes.fixed_amount, votes.amount)").to_i  # result is a string otherwise
    end
  end

  has_many :candidates
  has_many :candidate_results,
           :through => :candidates,
           :select => "candidate_results.result_id"

  has_many :alliance_results
  has_many :results, :through => :alliance_results

  belongs_to :advocate_user, :foreign_key => :primary_advocate_social_security_number, :primary_key => :ssn

  belongs_to :electoral_coalition
  ranks :signing_order, :with_same => :electoral_coalition_id

  scope :without_coalition, where(:electoral_coalition_id => nil)

  scope :not_real, joins(:candidates).where('candidates.candidate_name = electoral_alliances.name')

  scope :ready, where(:secretarial_freeze => true)

  validates_presence_of :name, :delivered_candidate_form_amount, :primary_advocate_social_security_number, :primary_advocate_email, :shorten

  def vote_sum_caches
    candidate_results.select(
      'candidate_results.result_id, sum(candidate_results.vote_sum_cache) as alliance_vote_sum_cache').group('candidate_results.result_id')
  end

  def freeze!
    # FIXME: This requires validation but the validaion is done in the controller.
    self.update_attribute :secretarial_freeze, true
  end

  def has_fix_needing_candidates?
    self.candidates.has_fixes.count > 0
  end

  def create_advocate
    ssn = self.primary_advocate_social_security_number
    return if ssn.nil? || ssn.empty? # Seed, etc
    unless AdvocateUser.find_by_ssn(ssn)
      AdvocateUser.create! :ssn => ssn, :email => self.primary_advocate_email
    end
  end

  def self.are_all_ready?
    self.count == self.ready.count
  end

  def self.create_advocates
    raise "all not ready" unless ElectoralAlliance.all.count == (ElectoralAlliance.all & ElectoralAlliance.ready).count
    self.all.each do |alliance|
      alliance.create_advocate
    end
  end

end
