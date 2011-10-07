module DrawBehaviour
  extend ActiveSupport::Concern

  included do
    has_many :candidate_results, :dependent => :nullify
    belongs_to :result

    validates_presence_of :result_id

    @@identifier_range = ('a'..'zzz').to_a

    def identifier_number=(number)
      self.identifier = @@identifier_range[number]
    end

    def self.affects_elected?(candidate_results)
      candidate_results.map(&:elected).include?(true)
    end
  end
end