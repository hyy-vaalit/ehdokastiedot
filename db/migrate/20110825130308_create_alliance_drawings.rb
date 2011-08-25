class CreateAllianceDrawings < ActiveRecord::Migration
  def self.up
    create_table :alliance_drawings do |t|
      t.integer :alliance_draw_id
      t.integer :electoral_alliance_id
      t.integer :position_in_alliance
      t.integer :position_in_draw
      t.timestamps
    end
  end

  def self.down
    drop_table :alliance_drawings
  end
end
