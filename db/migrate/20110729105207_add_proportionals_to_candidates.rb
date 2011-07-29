class AddProportionalsToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :alliance_proportional, :float
    add_column :candidates, :coalition_proportional, :float
  end

  def self.down
    remove_column :candidates, :coalition_proportional
    remove_column :candidates, :alliance_proportional
  end
end
