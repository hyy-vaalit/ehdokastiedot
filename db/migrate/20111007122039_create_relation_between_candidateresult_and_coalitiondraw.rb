class CreateRelationBetweenCandidateresultAndCoalitiondraw < ActiveRecord::Migration
  def self.up

    create_table :coalition_draws do |t|
      t.references :result
      t.string :identifier
      t.boolean :affects_elected_candidates

      t.timestamps
    end

    change_table :candidate_results do |t|
      t.references :coalition_draw
    end

    add_foreign_key(:coalition_draws, :results)
    add_foreign_key(:candidate_results, :coalition_draws)
  end

  def self.down
    change_table :candidate_results do |t|
      t.remove :coalition_draw_id
    end

    drop_table :coalition_draws
  end

end
