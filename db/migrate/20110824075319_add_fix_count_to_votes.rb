class AddFixCountToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :fix_count, :integer
  end

  def self.down
    remove_column :votes, :fix_count
  end
end
