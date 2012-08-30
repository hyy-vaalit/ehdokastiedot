class AddLoginEnabledToConfiguration < ActiveRecord::Migration
  def self.up
    add_column :global_configurations, :advocate_login_enabled, :boolean, :null => :false, :default => false
  end

  def self.down
    remove_column :global_configurations, :advocate_login_enabled
  end
end
