class AddDeviseToVotingAreaUsers < ActiveRecord::Migration
  def self.up

    create_table(:voting_area_users) do |t|
      t.string :email, :null => false

      t.database_authenticatable :null => false
      t.trackable
      t.timestamps
    end

    add_index :voting_area_users, :email, :unique => true

  end

  def self.down
    remove_index :voting_area_users, :email
    drop_table(:voting_area_users)

  end
end
