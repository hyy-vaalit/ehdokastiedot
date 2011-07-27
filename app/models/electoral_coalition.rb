class ElectoralCoalition < ActiveRecord::Base

  has_many :electoral_alliances

  def order_alliances alliance_data
    original_array = alliance_data.to_a
    sorted_array = original_array.sort {|x,y| x.last <=> y.last}
    ordered_hashes = sorted_array.map {|array| {:id => array.first, :position => array.last}}
    ordered_hashes.each do |hash|
      ElectoralAlliance.find_by_id(hash[:id]).update_attribute :signing_order_position, hash[:position]
    end
  end

end
