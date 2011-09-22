class AddForeignKeysToVotes < ActiveRecord::Migration
  def self.up
    add_foreign_key(:votes, :candidates)
    add_foreign_key(:votes, :voting_areas)
  end

  def self.down
    remove_foreign_key(:votes, :candidates)
    remove_foreign_key(:votes, :voting_areas)
  end
end
