class CreateElectoralCoalitions < ActiveRecord::Migration
  def self.up
    rename_table :electoral_circles, :electoral_coalitions
  end

  def self.down
    rename_table :electoral_coalitions, :electoral_circles
  end
end
