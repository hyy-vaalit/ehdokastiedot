class RemoveAllianceIdFromAdmin < ActiveRecord::Migration
  def self.up
    remove_column :admin_users, :electoral_alliance_id
  end

  def self.down
    raise "Irreversible migration blabla"
  end

end
