class CreateCandidateResults < ActiveRecord::Migration
  def self.up
    create_table :candidate_results do |t|
      t.references :result
      t.references :candidate
      t.integer :vote_sum_cache
      t.boolean :elected

      t.timestamps
    end

    add_foreign_key(:candidate_results, :results)
    add_foreign_key(:candidate_results, :candidates)
  end

  def self.down
    drop_table :candidate_results
  end
end
