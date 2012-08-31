class RemoveLegacyStateAttrsFromCandidate < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :state
    remove_column :candidates, :final_state
  end

  def self.down
    raise "Irreversible blaa blaa"
  end
end
