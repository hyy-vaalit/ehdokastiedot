class AddConstraintUniqueVotes < ActiveRecord::Migration
  def self.up
    add_index :votes, [:candidate_id, :voting_area_id], :unique => true, :name => "index_unique_votes_per_candidate_in_voting_area"
  end

  def self.down
    remove_index :votes, [:candidate_id, :voting_area_id], :unique => true, :name => "index_unique_votes_per_candidate_in_voting_area"
  end
end
