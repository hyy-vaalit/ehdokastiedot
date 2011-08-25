class AddFixedProportionalsToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :fixed_alliance_proportional, :float
    add_column :candidates, :fixed_coalition_proportional, :float
  end

  def self.down
    remove_column :candidates, :fixed_coalition_proportional
    remove_column :candidates, :fixed_alliance_proportional
  end
end
