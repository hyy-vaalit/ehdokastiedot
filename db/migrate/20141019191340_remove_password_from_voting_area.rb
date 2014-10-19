class RemovePasswordFromVotingArea < ActiveRecord::Migration
  def up
    remove_column :voting_areas, :encrypted_password
  end

  def down
    raise "cannot go down"
  end
end
