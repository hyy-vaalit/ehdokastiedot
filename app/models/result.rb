class Result < ActiveRecord::Base
  has_many :coalition_proportionals
  has_many :alliance_proportionals

  after_create :calculate_proportionals!

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
