module DrawBehaviour
  extend ActiveSupport::Concern

  included do
    has_many :candidate_results, :dependent => :nullify

    belongs_to :result

    scope :for_drawings, -> {
      includes(
        candidate_results: [
          candidate: [
            :electoral_alliance
          ]
        ]
      ).order("created_at asc")
    }

    validates_presence_of :result_id

    @@identifier_range = ('a'..'zzz').to_a

    def identifier_number=(number)
      self.identifier = identifier_from_number(number)
    end

    # Translates a unique identifier number (eg. an iterator index) to
    # a string (eg. "ax") which will be displayed as draw identifier in results.
    def identifier_from_number(number)
      @@identifier_range[number]
    end

    # If some of the draw's candidates have :elected status and some do not,
    # then the draw is effective. It is not effective if it affects
    # only candidates with :elected (all of them will be selected)
    # or when none of the candidates has :elected (none of them will be selected).
    def self.affects_elected?(candidate_results)
      status = candidate_results.map(&:elected)

      status.include?(true) and status.include?(false)
    end

    def give_order!(order_attribute, draw_orders, automatically = false)
      if automatically
        give_order_automatically!(order_attribute)
      else
        draw_orders.each do |candidate_result_id, draw_order|
          candidate_result = self.candidate_results.find(candidate_result_id)
          candidate_result.update_attributes!(order_attribute => draw_order)
        end
      end
    end

    def drawable_candidates
      candidate_results.select("candidates.id as candidate_id, candidates.candidate_name, candidates.candidate_number,
         candidate_results.id as candidate_result_id, candidate_results.elected as elected,
         electoral_alliances.shorten as alliance_shorten,
         electoral_coalitions.shorten as coalition_shorten,
         coalition_proportionals.number as coalition_proportional_number,
         alliance_proportionals.number as alliance_proportional_number,
         candidate_results.vote_sum_cache").joins(
       'INNER JOIN candidates              ON candidates.id = candidate_results.candidate_id').joins(
       'INNER JOIN alliance_proportionals  ON alliance_proportionals.candidate_id = candidates.id').joins(
       'INNER JOIN coalition_proportionals ON coalition_proportionals.candidate_id = candidates.id').joins(
       'INNER JOIN electoral_alliances     ON candidates.electoral_alliance_id = electoral_alliances.id').joins(
       'INNER JOIN electoral_coalitions    ON electoral_alliances.electoral_coalition_id = electoral_coalitions.id').where(
        "alliance_proportionals.result_id = ? AND coalition_proportionals.result_id = ?", self.result_id, self.result_id).order(
       'candidate_results.vote_sum_cache desc')
    end

    private

    def give_order_automatically!(order_attribute)
      random_order = Array(1..self.candidate_results.count).sort_by { rand }
      self.candidate_results.each_with_index {|c,i| c.update_attributes!(order_attribute => random_order[i])}
    end

  end
end
