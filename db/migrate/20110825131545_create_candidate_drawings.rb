class CreateCandidateDrawings < ActiveRecord::Migration
  def self.up
    create_table :candidate_drawings do |t|
      t.integer :candidate_draw_id
      t.integer :candidate_id
      t.integer :position_in_draw
      t.timestamps
    end
  end

  def self.down
    drop_table :candidate_drawings
  end
end
