class RemoveEnvAttrsFromGlobalConfiguration < ActiveRecord::Migration[5.0]
  def change
    remove_column :global_configurations, :candidate_data_is_freezed_at
    remove_column :global_configurations, :candidate_nomination_ends_at
  end
end
