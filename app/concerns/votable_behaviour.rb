module VotableBehaviour
  extend ActiveSupport::Concern

  included do

    has_many :votes do
      def preliminary_sum
        countable.sum("amount")
      end
    end

  end


end