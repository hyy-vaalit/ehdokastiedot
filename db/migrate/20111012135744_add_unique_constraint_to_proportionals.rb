class AddUniqueConstraintToProportionals < ActiveRecord::Migration
  def self.up
    add_index :coalition_proportionals, [:candidate_id, :result_id],
                                         :unique => true,
                                         :name => "index_unique_coalition_prop_per_candidate_and_result"
    add_index :alliance_proportionals, [:candidate_id, :result_id],
                                         :unique => true,
                                         :name => "index_unique_alliance_prop_per_candidate_and_result"
    add_index :alliance_results, [:electoral_alliance_id, :result_id],
                                   :unique => true,
                                   :name => "index_unique_alliance_result"
    add_index :coalition_results, [:electoral_coalition_id, :result_id],
                                   :unique => true,
                                   :name => "index_unique_coalition_result"
    add_index :candidate_results, [:candidate_id, :result_id],
                                   :unique => true,
                                   :name => "index_unique_candidate_result"
  end

  def self.down
    remove_index :coalition_proportionals, :name => "index_unique_coalition_prop_per_candidate_and_result"
    remove_index :alliance_proportionals, :name => "index_unique_alliance_prop_per_candidate_and_result"
    remove_index :alliance_results, :name => "index_unique_alliance_result"
    remove_index :coalition_results, :name => "index_unique_coalition_result"
    remove_index :candidate_results, :name => "index_unique_candidate_result"
  end
end
