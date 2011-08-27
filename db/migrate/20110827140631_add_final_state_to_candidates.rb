class AddFinalStateToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :final_state, :string
  end

  def self.down
    remove_column :candidates, :final_state
  end
end
