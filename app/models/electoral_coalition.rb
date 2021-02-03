class ElectoralCoalition < ActiveRecord::Base
  has_many :electoral_alliances, :dependent => :nullify
  has_many :candidates, :through => :electoral_alliances

  validates_presence_of :name, :shorten

  scope :by_numbering_order, -> { order("#{table_name}.numbering_order") }

  before_save :strip_whitespace_from_name_fields

  def order_alliances alliance_data
    original_array = alliance_data.to_a
    sorted_array = original_array.sort {|x,y| x.last <=> y.last}
    ordered_hashes = sorted_array.map {|array| {:id => array.first, :position => array.last}}

    ordered_hashes.each do |hash|
      self.electoral_alliances.find(hash[:id]).update_attribute :numbering_order_position, hash[:position]
    end
  end

  def self.are_all_ordered?
    self.where(:numbering_order => nil).count == 0
  end

  def self.give_orders coalition_data
    coalition_data.to_a.each do |array|
      self.find(array.first).update_attribute :numbering_order, array.last
    end
  end

  protected

  def strip_whitespace_from_name_fields
    self.name.strip!
    self.shorten.strip!
  end
end
