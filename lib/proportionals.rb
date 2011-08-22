module Proportionals

  def self.calculus!
    ElectoralCoalition.transaction do
      coalitions = ElectoralCoalition.all
      coalitions.each do |coalition|
        calculate_coalition_proportional(coalition)
        coalition.electoral_alliances.each do |alliance|
          calculate_alliance_proportional(alliance)
        end
      end
    end
    clear_selection_state
    mark_selected
  end

  private

  def self.calculate_alliance_proportional alliance
    total_votes = alliance.total_votes
    candidates = alliance.candidates.sort {|x,y| y.total_votes <=> x.total_votes}
    candidates.each_with_index do |candidate, i|
      candidate.update_attribute :alliance_proportional, (total_votes/(i+1))
    end
  end

  def self.calculate_coalition_proportional coalition
    total_votes = coalition.total_votes
    candidates = coalition.electoral_alliances.map(&:candidates).flatten.sort {|x,y| y.total_votes <=> x.total_votes}
    candidates.each_with_index do |candidate, i|
      candidate.update_attribute :coalition_proportional, (total_votes/(i+1))
    end
  end

  def self.clear_selection_state
    Candidate.all.each do |candidate|
      candidate.unselect_me!
    end
  end

  def self.mark_selected
    Candidate.selection_order.limit(REDIS.get('candidates_to_select')).each do |candidate|
      candidate.select_me!
    end
  end

end
