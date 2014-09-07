class AddForeignKeysToCandidate < ActiveRecord::Migration
  def change
    add_foreign_key(:candidates, :electoral_alliances)
    add_foreign_key(:electoral_alliances, :electoral_coalitions)
  end
end
