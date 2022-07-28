class ElectoralCoalition < ActiveRecord::Base
  has_many :electoral_alliances, :dependent => :nullify
  has_many :candidates, :through => :electoral_alliances

  validates_presence_of :name, :shorten

  scope :by_numbering_order, -> { order("#{table_name}.numbering_order") }

  before_validation :strip_whitespace_from_name_fields!

  def self.are_all_ordered?
    self.where(:numbering_order => nil).count == 0
  end

  # params := alliance_id => numbering_order
  #   <ActionController::Parameters {"9"=>"1", ..}
  def update_alliance_numbering_order!(params)
    params.each do |alliance_id, numbering_order|
      self.electoral_alliances.find(alliance_id).update!(numbering_order: numbering_order)
    end
  end

  # params := coalition_id => numbering_order
  #   <ActionController::Parameters {"9"=>"1", ..}
  def self.update_coalition_numbering_order!(params)
    params.each do |coalition_id, numbering_order|
      self.find(coalition_id).update!(numbering_order: numbering_order)
    end
  end

  protected

  def strip_whitespace_from_name_fields!
    self.name.strip!
    self.shorten.strip!
  end
end
