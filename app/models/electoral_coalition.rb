class ElectoralCoalition < ActiveRecord::Base

  has_many :electoral_alliances

  default_scope order(:number_order)

  def order_alliances alliance_data
    original_array = alliance_data.to_a
    sorted_array = original_array.sort {|x,y| x.last <=> y.last}
    ordered_hashes = sorted_array.map {|array| {:id => array.first, :position => array.last}}
    ordered_hashes.each do |hash|
      self.electoral_alliances.find_by_id(hash[:id]).update_attribute :signing_order_position, hash[:position]
    end
  end

  def total_votes
    self.electoral_alliances.map(&:total_votes).sum
  end

  def self.give_orders coalition_data
    coalition_data.to_a.each do |array|
      self.find_by_id(array.first).update_attribute :number_order, array.last
    end
  end

end
