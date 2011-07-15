class RemoveNicknameFromCandidate < ActiveRecord::Migration
  def self.up
    remove_column :candidates, :nickname
  end

  def self.down
    add_column :candidates, :nickname, :string
  end
end
