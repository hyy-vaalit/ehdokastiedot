class CreateCoalitionDraws < ActiveRecord::Migration
  def self.up
    create_table :coalition_draws do |t|
      t.boolean :affects
      t.timestamps
    end
  end

  def self.down
    drop_table :coalition_draws
  end
end
