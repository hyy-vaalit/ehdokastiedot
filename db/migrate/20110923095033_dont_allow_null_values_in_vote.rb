class DontAllowNullValuesInVote < ActiveRecord::Migration
  def self.up
    change_column :votes, :voting_area_id, :integer, :null => false
    change_column :votes, :candidate_id, :integer, :null => false
  end

  def self.down
    change_column :votes, :voting_area_id, :integer, :null => true
    change_column :votes, :candidate_id, :integer, :null => true
  end
end
