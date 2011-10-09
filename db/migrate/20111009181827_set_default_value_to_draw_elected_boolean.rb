class SetDefaultValueToDrawElectedBoolean < ActiveRecord::Migration
  def self.up
    change_column :candidate_results, :elected, :boolean, :default => false, :null => false
    change_column :alliance_draws, :affects_elected_candidates, :boolean, :default => false, :null => false
    change_column :coalition_draws, :affects_elected_candidates, :boolean, :default => false, :null => false
  end

  def self.down
    change_column :candidate_results, :elected, :boolean
    change_column :coalition_draws, :affects_elected_candidates, :boolean
    change_column :alliance_draws, :affects_elected_candidates, :boolean
  end
end
