class RenameVoteCountToAmount < ActiveRecord::Migration
  def self.up
    rename_column :votes, :vote_count, :amount
    change_column :votes, :amount, :integer, :null => false
  end

  def self.down
    rename_column :votes, :amount, :vote_count
  end
end
