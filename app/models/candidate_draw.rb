class CandidateDraw < ActiveRecord::Base

  has_many :candidate_drawings
  has_many :candidates, :through => :candidate_drawings

  def self.check_inside_alliances
    ElectoralAlliance.candidates.selection_order.all.each do |alliance|
      pairs = {}
      alliance.candidates.each do |candidate|
        pairs[candidate.total_votes] ||= []
        pairs[candidate.total_votes] << candidate
      end
      arrange_draws pairs
    end
    true
  end

  def self.arrange_draws pairs
    pairs.each do |key,value|
      next unless value.count > 1
      draw = CandidateDraw.create
      draw.candidates = value
      draw.save
    end
  end

end
