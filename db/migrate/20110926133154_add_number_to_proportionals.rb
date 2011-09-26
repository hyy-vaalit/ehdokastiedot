class AddNumberToProportionals < ActiveRecord::Migration
  def self.up
    add_column :alliance_proportionals, :number, :float
    add_column :coalition_proportionals, :number, :float
  end

  def self.down
    remove_column :alliance_proportionals, :number, :float
    remove_column :coalition_proportionals, :number, :float
  end
end
