class CreateVotingAreas < ActiveRecord::Migration
  def self.up
    create_table :voting_areas do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :voting_areas
  end
end
