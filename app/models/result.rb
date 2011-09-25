class Result < ActiveRecord::Base
  has_many :coalition_proportionals
  has_many :alliance_proportionals

  after_create :calculate_proportionals!

  protected

  def calculate_proportionals!
    alliance_proportionals!
    coalition_proportionals!
  end

  def alliance_proportionals!
    AllianceProportional.calculate!
  end

  def coalition_proportionals!
    CoalitionProportional.calculate!
  end

end
