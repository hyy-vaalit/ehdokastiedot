module Proportionals

  def self.calculus!
    ElectoralCoalition.transaction do
      coalitions = ElectoralCoalition.all
      coalitions.each do |coalition|
        coalition.electoral_alliances.each do |alliance|
          calculate_alliance_proportional(alliance)
        end
        calculate_coalition_proportional(coalition)
      end
      clear_selection_state
      mark_selected
      mark_spares
    end
  end

  def self.fixed_calculus!
    ElectoralCoalition.transaction do
      coalitions = ElectoralCoalition.all
      coalitions.each do |coalition|
        coalition.electoral_alliances.each do |alliance|
          calculate_alliance_proportional(alliance, true)
        end
        calculate_coalition_proportional(coalition, true)
      end
      clear_selection_state
      mark_selected
      mark_spares
    end
  end

  private

  def self.calculate_alliance_proportional alliance, fixed = false
    compare_method = fixed ? :fixed_total_votes : :total_votes
    total_votes = alliance.total_votes
    candidates = alliance.candidates.sort {|x,y| y.method(compare_method).call <=> x.method(compare_method).call}
    candidates.each_with_index do |candidate, i|
      candidate.update_attribute (fixed ? :fixed_alliance_proportional : :alliance_proportional), sprintf("%.5f", total_votes.to_f/(i+1)).to_f
    end
  end

  def self.calculate_coalition_proportional coalition, fixed = false
    compare_method = fixed ? :fixed_alliance_proportional : :alliance_proportional
    total_votes = coalition.total_votes
    candidates = coalition.electoral_alliances.map(&:candidates).flatten.sort {|x,y| y.method(compare_method).call <=> x.method(compare_method).call}
    candidates.each_with_index do |candidate, i|
      candidate.update_attribute (fixed ? :fixed_coalition_proportional : :coalition_proportional), sprintf("%.5f", total_votes.to_f/(i+1)).to_f
    end
  end

  def self.clear_selection_state
    Candidate.all.each do |candidate|
      candidate.unselect_me!
    end
  end

  def self.mark_selected
    candidates_to_select = REDIS.get('candidates_to_select')
    Candidate.selection_order.limit(candidates_to_select).each do |candidate|
      candidate.select_me!
    end
  end

  def self.mark_spares
    spare_candidates_to_select = REDIS.get('spare_candidates_to_select').to_i
    ElectoralAlliance.all.each do |alliance|
      how_many_selected = alliance.candidates.selected.count
      spare_count = how_many_selected * spare_candidates_to_select
      alliance.candidates.where(:state => :not_selected).order('alliance_proportional desc').limit(spare_count).each do |candidate|
        candidate.spare_me!
      end
    end
  end

end
