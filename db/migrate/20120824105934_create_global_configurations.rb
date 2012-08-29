class CreateGlobalConfigurations < ActiveRecord::Migration
  def self.up
    create_table :global_configurations do |t|

      t.timestamp :candidate_nomination_ends_at, :null => false
      t.timestamp :candidate_data_is_freezed_at, :null => false

      t.integer :votes_given,    :default => 0
      t.integer :votes_accepted, :default => 0
      t.integer :voters_count,   :default => 0
      t.integer :potential_voters_count, :default => 0

      t.string :mail_from_address, :null => false
      t.string :mail_from_name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :global_configurations
  end
end
