class DestroyDeadDrawingTables < ActiveRecord::Migration
  def self.up
    drop_table :alliance_draws
    drop_table :alliance_drawings
    drop_table :candidate_draws
    drop_table :candidate_drawings
    drop_table :coalition_draws
    drop_table :coalition_drawings

  end

  def self.down
    raise "irreversible migration"
  end
end
