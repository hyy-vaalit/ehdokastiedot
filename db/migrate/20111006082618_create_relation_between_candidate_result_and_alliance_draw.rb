class CreateRelationBetweenCandidateResultAndAllianceDraw < ActiveRecord::Migration
  def self.up

    create_table :alliance_draws do |t|
      t.references :result
      t.timestamps
    end

    change_table :candidate_results do |t|
      t.references :alliance_draw
    end

    add_foreign_key(:alliance_draws, :results)
    add_foreign_key(:candidate_results, :alliance_draws)
  end

  def self.down
    change_table :candidate_results do |t|
      t.remove :alliance_draw_id
    end

    drop_table :alliance_draws
  end
end
