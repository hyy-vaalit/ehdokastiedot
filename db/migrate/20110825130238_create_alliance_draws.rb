class CreateAllianceDraws < ActiveRecord::Migration
  def self.up
    create_table :alliance_draws do |t|
      t.boolean :affects
      t.timestamps
    end
  end

  def self.down
    drop_table :alliance_draws
  end
end
