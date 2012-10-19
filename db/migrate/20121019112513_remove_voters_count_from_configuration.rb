class RemoveVotersCountFromConfiguration < ActiveRecord::Migration
  def self.up
    remove_column :global_configurations, :voters_count
  end

  def self.down
    add_column :global_configurations, :voters_count, :integer, :default => 0
  end
end
