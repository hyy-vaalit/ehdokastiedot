class CreateVotingAreaStateAttributes < ActiveRecord::Migration
  def self.up
    remove_column :voting_areas, :taken
    remove_column :voting_areas, :calculated
    add_column    :voting_areas, :submitted, :boolean, :null => false, :default => false
    change_column :voting_areas, :ready, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :voting_areas, :submitted
    add_column :voting_areas, :taken, :boolean, :default => false
    add_column :voting_areas, :calculated, :boolean, :default => false
    change_column :voting_areas, :ready, :boolean, :default => false
  end
end
