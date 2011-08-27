class CandidateDraw < ActiveRecord::Base

  has_many :candidate_drawings
  has_many :candidates, :through => :candidate_drawings

  scope :ready, where(drawed: true)

  def self.check_inside_alliances
    ElectoralAlliance.all.each do |alliance|
      pairs = {}
      alliance.candidates.selection_order.each do |candidate|
        pairs[candidate.fixed_total_votes] ||= []
        pairs[candidate.fixed_total_votes] << candidate
      end
      arrange_draws pairs
    end
    true
  end

  def self.arrange_draws pairs
    pairs.each do |key,value|
      next unless value.count > 1
      draw = CandidateDraw.new
      draw.candidates = value
      draw.save
    end
  end

end
