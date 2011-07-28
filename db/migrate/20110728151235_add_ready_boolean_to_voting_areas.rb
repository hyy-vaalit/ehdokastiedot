class AddReadyBooleanToVotingAreas < ActiveRecord::Migration
  def self.up
    add_column :voting_areas, :ready, :boolean, :default => :false
  end

  def self.down
    remove_column :voting_areas, :ready
  end
end
