class AddOrderNumberToDraws < ActiveRecord::Migration
  def self.up
    change_table :candidate_results do |t|
      t.integer :alliance_draw_order
      t.integer :coalition_draw_order
    end
  end

  def self.down
    change_table :candidate_results do |t|
      t.remove :alliance_draw_order
      t.remove :coalition_draw_order
    end
  end

end
