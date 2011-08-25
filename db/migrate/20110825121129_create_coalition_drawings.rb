class CreateCoalitionDrawings < ActiveRecord::Migration
  def self.up
    create_table :coalition_drawings do |t|
      t.integer :coalition_draw_id
      t.integer :electoral_coalition_id
      t.integer :position_in_coalition
      t.integer :position_in_draw
      t.timestamps
    end
  end

  def self.down
    drop_table :coalition_drawings
  end
end
