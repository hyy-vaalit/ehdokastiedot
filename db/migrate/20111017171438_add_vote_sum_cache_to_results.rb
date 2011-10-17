class AddVoteSumCacheToResults < ActiveRecord::Migration
  def self.up
    change_table :results do |t|
      t.integer :vote_sum_cache, :default => 0, :null => false
    end
  end

  def self.down
    change_table :results do |t|
      t.remove :vote_sum_cache
    end
  end
end
