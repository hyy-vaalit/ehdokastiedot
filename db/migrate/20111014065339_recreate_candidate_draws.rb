class RecreateCandidateDraws < ActiveRecord::Migration
  def self.up

    create_table :candidate_draws do |t|
      t.references :result
      t.string :identifier
      t.boolean :affects_elected_candidates

      t.timestamps
    end

    change_table :candidate_results do |t|
      t.references :candidate_draw
      t.integer :candidate_draw_order
    end

    add_foreign_key(:candidate_draws, :results)
    add_foreign_key(:candidate_results, :candidate_draws)
  end

  def self.down
    change_table :candidate_results do |t|
      t.remove :candidate_draw_id
      t.remove :candidate_draw_order
    end

    drop_table :candidate_draws
  end

end
