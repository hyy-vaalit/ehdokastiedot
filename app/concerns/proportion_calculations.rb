module ProportionCalculations
  extend ActiveSupport::Concern

  included do

    private

    def self.calculate_proportional(votes, array_index)
      (votes.to_f / (array_index + 1)).round(Vaalit::Voting::PROPORTIONAL_PRECISION)
    end

  end

  module ClassMethods
    # Params:
    #  :result_id => result.id,
    #  :candidate_id => candidate.id,
    #  :number => proportional_number
    def create_or_update!(opts = {})
      if existing = self.where(:candidate_id => opts[:candidate_id]).where(:result_id => opts[:result_id]).first
        existing.update_attributes!(:number => opts[:number])
      else
        self.create!(opts)
      end
    end

    def find_duplicate_numbers(result_id)
      select("#{table_name}.number").from(table_name).where(
      "#{table_name}.result_id = ?", result_id).group(
      "#{table_name}.number having count(*) > 1").order("#{table_name}.number desc")
    end
  end

end