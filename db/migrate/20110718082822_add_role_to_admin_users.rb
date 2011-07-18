class AddRoleToAdminUsers < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :role, :string
  end

  def self.down
    remove_column :admin_users, :role
  end
end
