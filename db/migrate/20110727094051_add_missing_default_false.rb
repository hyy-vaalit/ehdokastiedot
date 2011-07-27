class AddMissingDefaultFalse < ActiveRecord::Migration
  def self.up
    change_column :data_fixes, :applied, :boolean, :default => false
    change_column :electoral_alliances, :secretarial_freeze, :boolean, :default => false
  end

  def self.down
    change_column :data_fixes, :applied, :boolean
    change_column :electoral_alliances, :electoral_alliances
  end
end
