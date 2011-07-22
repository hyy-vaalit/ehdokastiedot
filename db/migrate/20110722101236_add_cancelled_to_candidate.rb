class AddCancelledToCandidate < ActiveRecord::Migration
  def self.up
    add_column :candidates, :cancelled, :boolean, :default => false
  end

  def self.down
    remove_column :candidates, :cancelled
  end
end
