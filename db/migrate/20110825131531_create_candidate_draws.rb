class CreateCandidateDraws < ActiveRecord::Migration
  def self.up
    create_table :candidate_draws do |t|
      t.boolean :affects
      t.timestamps
    end
  end

  def self.down
    drop_table :candidate_draws
  end
end
