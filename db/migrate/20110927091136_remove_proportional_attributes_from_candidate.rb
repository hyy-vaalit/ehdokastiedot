class RemoveProportionalAttributesFromCandidate < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :coalition_proportional
    remove_column :candidates, :alliance_proportional
    remove_column :candidates, :fixed_coalition_proportional
    remove_column :candidates, :fixed_alliance_proportional
  end

  def self.down
    add_column :candidates, :alliance_proportional, :float
    add_column :candidates, :coalition_proportional, :float
    add_column :candidates, :fixed_alliance_proportional, :float
    add_column :candidates, :fixed_coalition_proportional, :float
  end
end
