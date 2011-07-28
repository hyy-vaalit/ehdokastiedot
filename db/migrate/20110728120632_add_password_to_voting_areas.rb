class AddPasswordToVotingAreas < ActiveRecord::Migration
  def self.up
    add_column :voting_areas, :encrypted_password, :string
  end

  def self.down
    remove_column :voting_areas, :encrypted_password
  end
end
