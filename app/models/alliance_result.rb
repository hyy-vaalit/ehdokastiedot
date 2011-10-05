class AllianceResult < ActiveRecord::Base
  belongs_to :result
  belongs_to :electoral_alliance

  def self.for_alliances(alliance_ids)
    find(:all, :conditions => ["electoral_alliance_id IN (?)", alliance_ids])
  end
end
