module DrawBehaviour
  extend ActiveSupport::Concern

  included do
    has_many :candidate_results, :dependent => :nullify
    belongs_to :result

    scope :effective, where(:affects_elected_candidates => true) # TODO: spares

    validates_presence_of :result_id

    @@identifier_range = ('a'..'zzz').to_a

    # Translates a unique identifier number (eg. an iterator index) to
    # a string (eg. "ax") which will be displayed as draw identifier in results.
    def identifier_number=(number)
      self.identifier = @@identifier_range[number]
    end

    # If some of the draw's candidates have :elected status and some do not,
    # then the draw is effective. It is not effective if it affects
    # only candidates with :elected (all of them will be selected)
    # or when none of the candidates has :elected (none of them will be selected).
    def self.affects_elected?(candidate_results)
      status = candidate_results.map(&:elected)

      status.include?(true) and status.include?(false)
    end

    def give_order!(order_attribute, draw_order)
      draw_order.each do |candidate_result_id, draw_order|
        candidate_result = self.candidate_results.find(candidate_result_id)
        candidate_result.update_attributes!(order_attribute => draw_order)
      end
    end
  end
end