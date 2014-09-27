class AddReferenceToVotingAreaInVotingAreaUser < ActiveRecord::Migration
  def change
    add_column :voting_area_users, :voting_area_id, :int, :null => false

    add_foreign_key :voting_area_users, :voting_areas
  end
end
