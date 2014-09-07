class AddCheckingMinutesUserToGlobalConf < ActiveRecord::Migration
  def change
    add_column :global_configurations, :checking_minutes_username, :string, :null => false
    add_column :global_configurations, :checking_minutes_password, :string, :null => false
  end
end
