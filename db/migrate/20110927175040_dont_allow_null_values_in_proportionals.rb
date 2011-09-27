class DontAllowNullValuesInProportionals < ActiveRecord::Migration
  def self.up
    change_column :alliance_proportionals, :number, :float, :null => false
    change_column :alliance_proportionals, :candidate_id, :integer, :null => false
    change_column :alliance_proportionals, :result_id, :integer, :null => false

    change_column :coalition_proportionals, :number, :float, :null => false
    change_column :coalition_proportionals, :candidate_id, :integer, :null => false
    change_column :coalition_proportionals, :result_id, :integer, :null => false
  end

  def self.down
    change_column :alliance_proportionals, :number, :float, :null => true
    change_column :alliance_proportionals, :candidate_id, :integer, :null => true
    change_column :alliance_proportionals, :result_id, :integer, :null => true

    change_column :coalition_proportionals, :number, :float, :null => true
    change_column :coalition_proportionals, :candidate_id, :integer, :null => true
    change_column :coalition_proportionals, :result_id, :integer, :null => true
  end
end
