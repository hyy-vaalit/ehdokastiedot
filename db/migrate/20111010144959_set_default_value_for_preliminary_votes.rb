class SetDefaultValueForPreliminaryVotes < ActiveRecord::Migration
  def self.up
    change_column :votes, :amount, :integer, :default => 0, :null => false
  end

  def self.down
    change_column :votes, :amount, :integer, :null => false
  end
end
