class AddTakenToVotingAreas < ActiveRecord::Migration
  def self.up
    add_column :voting_areas, :taken, :boolean, :default => false
  end

  def self.down
    remove_column :voting_areas, :taken
  end
end
