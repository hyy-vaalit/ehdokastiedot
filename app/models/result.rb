class Result < ActiveRecord::Base
  has_many :coalition_proportionals
  has_many :alliance_proportionals

  has_many :candidates, :through => :coalition_proportionals

  after_create :calculate_proportionals!

  def ordered_candidates
    self.candidates.by_coalition_proportional.select('
      "alliance_proportionals".number as alliance_proportional').joins(
      'inner join "alliance_proportionals" ON "candidates".id = alliance_proportionals.candidate_id')
  end

  def elected_candidates
    self.ordered_candidates.limit(Vaalit::Voting::ELECTED_CANDIDATE_COUNT)
  end

  protected

  def calculate_proportionals!
    Result.transaction do
      alliance_proportionals!
      coalition_proportionals!
    end
  end

  def alliance_proportionals!
    AllianceProportional.calculate!(self)
  end

  def coalition_proportionals!
    CoalitionProportional.calculate!(self)
  end

end
