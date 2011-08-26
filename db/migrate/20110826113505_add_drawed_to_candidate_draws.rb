class AddDrawedToCandidateDraws < ActiveRecord::Migration
  def self.up
    add_column :candidate_draws, :drawed, :boolean
  end

  def self.down
    remove_column :candidate_draws, :drawed
  end
end
