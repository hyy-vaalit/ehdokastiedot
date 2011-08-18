class RemoveConfigurations < ActiveRecord::Migration
  def self.up
    drop_table :configurations
  end

  def self.down
    create_table :configurations do |t|
      t.string :key
      t.string :value
      t.timestamps
    end
  end
end
