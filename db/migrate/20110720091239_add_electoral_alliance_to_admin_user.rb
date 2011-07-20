class AddElectoralAllianceToAdminUser < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :electoral_alliance_id, :integer
  end

  def self.down
    remove_column :admin_users, :electoral_alliance_id
  end
end
