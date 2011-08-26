class AddDrawedToAllianceDraws < ActiveRecord::Migration
  def self.up
    add_column :alliance_draws, :drawed, :boolean
  end

  def self.down
    remove_column :alliance_draws, :drawed
  end
end
