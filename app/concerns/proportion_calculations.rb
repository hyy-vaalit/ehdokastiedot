module ProportionCalculations
  extend ActiveSupport::Concern

  included do

    private

    def self.calculate_proportional(votes, array_index)
      (votes.to_f / (array_index + 1)).round(Vaalit::Voting::PROPORTIONAL_PRECISION)
    end

  end


end