class AddMarkedInvalidToCandidate < ActiveRecord::Migration
  def self.up
    add_column :candidates, :marked_invalid, :boolean, :default => false
  end

  def self.down
    remove_column :candidates, :marked_invalid
  end
end
