module Proportionals

  def self.calculus!
    coalitions = ElectoralCoalition.all
    coalitions.each do |coalition|
      calculate_coalition_proportional(coalition)
      coalition.electoral_alliances.each do |alliance|
        calculate_alliance_proportional(alliance)
      end
    end
    calculate_proportionals_for_single_candidate
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

  def self.calculate_proportionals_for_single_candidate
    ElectoralAlliance.where(:electoral_coalition_id => nil).each do |alliance|
      candidates = alliance.candidates.sort {|x,y| y.total_votes <=> x.total_votes}
      candidates.each_with_index do |candidate, i|
        number = (alliance.total_votes/(i+1))
        candidate.update_attribute :alliance_proportional, number
        candidate.update_attribute :coalition_proportional, number
      end
    end
  end

end
