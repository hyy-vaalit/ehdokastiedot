class AddStateToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :state, :string, :default => 'not_selected'
  end

  def self.down
    remove_column :candidates, :state
  end
end
