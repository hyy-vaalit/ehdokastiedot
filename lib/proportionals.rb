module Proportionals

  def self.calculus!
    ElectoralCoalition.transaction do
      coalitions = ElectoralCoalition.all
      coalitions.each do |coalition|
        puts "Proportionals.calculus! calculating results for coalition #{coalition.name}"
        coalition.electoral_alliances.each do |alliance|
          calculate_alliance_proportional(alliance)
        end
        calculate_coalition_proportional(coalition)
      end
      puts "Proportionals.calculus! clearing selection state"
      clear_selection_state
      puts "Proportionals.calculus! marking selected"
      mark_selected
      puts "Proportionals.calculus! marking spares"
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

  def self.final_position!
    Candidate.transaction do
      clear_finally_selection_state
      mark_finally_selected
      mark_finally_spares
    end
    true
  end

  private

  def self.calculate_alliance_proportional alliance, fixed = false
    compare_method = fixed ? :fixed_total_votes : :total_votes
    total_votes = alliance.total_votes
    candidates = alliance.candidates.sort {|x,y| y.method(compare_method).call <=> x.method(compare_method).call}
    puts "Proportionals.calculus! calculating alliance proportional for #{alliance.name} with #{candidates.size} candidates"
    candidates.each_with_index do |candidate, i|
      candidate.update_attribute (fixed ? :fixed_alliance_proportional : :alliance_proportional), sprintf("%.5f", total_votes.to_f/(i+1)).to_f
    end
  end

  def self.calculate_coalition_proportional coalition, fixed = false
    compare_method = fixed ? :fixed_alliance_proportional : :alliance_proportional
    total_votes = coalition.total_votes
    candidates = coalition.electoral_alliances.map(&:candidates).flatten.sort {|x,y| y.method(compare_method).call <=> x.method(compare_method).call}
    puts "Proportionals.calculus! calculating coalition proportional for #{coalition.name} with #{candidates.size} candidates"
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

  def self.clear_finally_selection_state
    Candidate.all.each do |candidate|
      candidate.unselect_me_at_last!
    end
  end

  def self.mark_finally_selected
    candidates_to_select = REDIS.get('candidates_to_select').to_i
    Candidate.final_order[0...candidates_to_select].each do |candidate|
      candidate.select_me_at_last!
    end
  end

  def self.mark_finally_spares
    spare_candidates_to_select = REDIS.get('spare_candidates_to_select').to_i
    ElectoralAlliance.all.each do |alliance|
      how_many_selected = alliance.candidates.selected_at_last.count
      spare_count = how_many_selected * spare_candidates_to_select
      alliance.candidates.where(:final_state => :not_selected_at_all).order('fixed_alliance_proportional desc').limit(spare_count).each do |candidate|
        candidate.spare_me_at_last!
      end
    end
  end

end
