class AllianceDraw < ActiveRecord::Base

  has_many :alliance_drawings
  has_many :electoral_alliances, :through => :alliance_drawings

  scope :ready, where(drawed: true)

  def self.check_between_alliances
    ElectoralCoalition.all.each do |coalition|
      pairs = {}
      coalition.electoral_alliances.each do |alliance|
        alliance.candidates.selection_order.each_with_index do |candidate, i|
          next unless candidate.fixed_alliance_proportional
          pairs[candidate.fixed_alliance_proportional] ||= []
          pairs[candidate.fixed_alliance_proportional] << {order: i, alliance: alliance.id}
        end
      end
      arrange_draws pairs
    end
    true
  end

  def self.arrange_draws pairs
    pairs.each do |key,value|
      next unless value.count > 1
      draw = AllianceDraw.create
      value.each do |data|
        draw.alliance_drawings.create :electoral_alliance_id => data[:alliance], :position_in_alliance => data[:order]
      end
      draw.destroy if draw.alliance_drawings.empty?
    end
  end

end
