class AddCalculatedToVotingArea < ActiveRecord::Migration
  def self.up
    add_column :voting_areas, :calculated, :boolean
  end

  def self.down
    remove_column :voting_areas, :calculated
  end
end
