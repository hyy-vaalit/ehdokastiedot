class AddDrawedToCoalitionDraws < ActiveRecord::Migration
  def self.up
    add_column :coalition_draws, :drawed, :boolean
  end

  def self.down
    remove_column :coalition_draws, :drawed
  end
end
