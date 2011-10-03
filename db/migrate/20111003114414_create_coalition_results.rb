class CreateCoalitionResults < ActiveRecord::Migration
  def self.up
    create_table :coalition_results do |t|
      t.references :result
      t.references :electoral_coalition
      t.integer :vote_sum_cache

      t.timestamps
    end

    add_foreign_key(:coalition_results, :results)
    add_foreign_key(:coalition_results, :electoral_coalitions)
  end

  def self.down
    drop_table :coalition_results
  end
end
