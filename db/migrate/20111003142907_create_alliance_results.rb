class CreateAllianceResults < ActiveRecord::Migration
  def self.up
    create_table :alliance_results do |t|
      t.references :result
      t.references :electoral_alliance
      t.integer :vote_sum_cache

      t.timestamps
    end

    add_foreign_key(:alliance_results, :results)
    add_foreign_key(:alliance_results, :electoral_alliances)
  end

  def self.down
    drop_table :alliance_results
  end
end
