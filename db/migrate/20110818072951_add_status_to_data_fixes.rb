class AddStatusToDataFixes < ActiveRecord::Migration
  def self.up
    add_column :data_fixes, :status, :boolean
  end

  def self.down
    remove_column :data_fixes, :status
  end
end
