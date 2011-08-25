class CoalitionDraw < ActiveRecord::Base

  has_many :coalition_drawings
  has_many :electoral_coalitions, :through => :coalition_drawings

  def self.check_between_coalitions
    pairs = {}
    Candidate.selection_order.all.each_with_index do |candidate, i|
      next unless candidate.fixed_coalition_proportional
      pairs[candidate.fixed_coalition_proportional] ||= []
      pairs[candidate.fixed_coalition_proportional] << {order: i, coalition: candidate.electoral_alliance.electoral_coalition.id}
    end
    arrange_draws pairs
    true
  end

  def self.arrange_draws pairs
    pairs.each do |key,value|
      next unless value.count > 1
      CoalitionDraw.transaction do
        draw = CoalitionDraw.create
        value.each do |data|
          draw.coalition_drawings.create :electoral_coalition_id => data[:coalition], :position_in_coalition => data[:order]
        end
        draw.destroy if draw.coalition_drawings.empty?
      end
    end
  end

end
