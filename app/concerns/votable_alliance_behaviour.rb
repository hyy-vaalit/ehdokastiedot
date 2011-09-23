module VotableAllianceBehaviour
  extend ActiveSupport::Concern

  included do

    has_many :votes, :through => :candidates do
      def preliminary_sum
        countable.sum("amount")
      end
    end

  end


end
