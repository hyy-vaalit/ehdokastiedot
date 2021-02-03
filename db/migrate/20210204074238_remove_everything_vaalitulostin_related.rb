class RemoveEverythingVaalitulostinRelated < ActiveRecord::Migration[5.2]
  def change
    drop_table :candidate_results
    drop_table :alliance_results
    drop_table :coalition_results

    drop_table :alliance_proportionals
    drop_table :coalition_proportionals

    drop_table :candidate_draws
    drop_table :alliance_draws
    drop_table :coalition_draws

    drop_table :results
    drop_table :voters
    drop_table :votes
    drop_table :voting_area_users
    drop_table :voting_areas

    remove_column :global_configurations, :votes_given
    remove_column :global_configurations, :votes_accepted
    remove_column :global_configurations, :potential_voters_count
    remove_column :global_configurations, :checking_minutes_username
    remove_column :global_configurations, :checking_minutes_password
  end
end
