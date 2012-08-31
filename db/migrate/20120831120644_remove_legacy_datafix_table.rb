class RemoveLegacyDatafixTable < ActiveRecord::Migration
  def self.up
    drop_table :data_fixes
  end

  def self.down
    raise "Irreversible blabla"
  end
end
