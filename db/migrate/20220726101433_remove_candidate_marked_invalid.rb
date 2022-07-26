class RemoveCandidateMarkedInvalid < ActiveRecord::Migration[6.1]
  def change
    remove_column :candidates, :marked_invalid
  end
end
