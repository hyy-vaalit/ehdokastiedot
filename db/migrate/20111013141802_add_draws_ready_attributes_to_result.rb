class AddDrawsReadyAttributesToResult < ActiveRecord::Migration
  def self.up
    change_table :results do |t|
      t.boolean :candidate_draws_ready, :default => false, :null => false
      t.boolean :alliance_draws_ready, :default => false, :null => false
      t.boolean :coalition_draws_ready, :default => false, :null => false
    end
  end

  def self.down
    change_table :results do |t|
      t.remove :candidate_draws_ready
      t.remove :alliance_draws_ready
      t.remove :coalition_draws_ready
    end
  end
end
