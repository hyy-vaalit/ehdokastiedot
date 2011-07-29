module Proportionals

  def self.calculus!
    coalitions = ElectoralCoalition.all
    coalitions.each do |coalition|
      calculate_coalition_proportional(coalition)
      coalition.electoral_alliances.each do |alliance|
        calculate_alliance_proportional(alliance)
      end
    end
  end

  private

  def self.calculate_alliance_proportional alliance
    total_votes = alliance.total_votes
    candidates = alliance.candidates.sort {|x,y| x.total_votes <=> y.total_votes}
    candidates.each_with_index do |candidate, i|
      candidate.update_attribute :alliance_proportional, (total_votes/(i+1))
    end
  end

  def self.calculate_coalition_proportional coalition
    total_votes = coalition.total_votes
    candidates = coalition.electoral_alliances.map(&:candidates).flatten.sort {|x,y| x.total_votes <=> y.total_votes}
    candidates.each_with_index do |candidate, i|
      candidate.update_attribute :coalition_proportional, (total_votes/(i+1))
    end
  end

end
