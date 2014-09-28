class AddIndexNameToVoters < ActiveRecord::Migration
  def change
    add_index :voters, :name
  end
end
