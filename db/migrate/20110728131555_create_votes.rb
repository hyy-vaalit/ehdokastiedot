class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :voting_area_id
      t.integer :candidate_id
      t.integer :vote_count

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
