class CreateDataFixes < ActiveRecord::Migration
  def self.up
    create_table :data_fixes do |t|
      t.integer :candidate_id
      t.string :field_name
      t.string :old_value
      t.string :new_value
      t.boolean :applied

      t.timestamps
    end
  end

  def self.down
    drop_table :data_fixes
  end
end
