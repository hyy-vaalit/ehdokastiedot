class AddUniqueIndexToCandidateNumber < ActiveRecord::Migration[8.0]
  def change
    # Postgres allows multiple NULLs in a unique index, so cancelled
    # candidates (candidate_number NULL) are fine.
    add_index :candidates, :candidate_number, unique: true
  end
end
