class RenameFinalVoteAmountColumn < ActiveRecord::Migration
  def self.up
    rename_column :votes, :fix_count, :fixed_amount
  end

  def self.down
    rename_column :votes, :fixed_amount, :fix_count
  end
end
