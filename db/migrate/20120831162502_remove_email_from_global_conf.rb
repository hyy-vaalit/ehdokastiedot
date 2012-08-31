class RemoveEmailFromGlobalConf < ActiveRecord::Migration
  def self.up
    remove_column :global_configurations, :mail_from_address
    remove_column :global_configurations, :mail_from_name

  end

  def self.down
    raise "Irreversible jne"
  end
end
