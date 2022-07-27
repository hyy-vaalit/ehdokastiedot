class AllowSingleNonCancelledCandidate < ActiveRecord::Migration[6.1]
  def change
    # https://www.postgresql.org/docs/current/indexes-partial.html#INDEXES-PARTIAL-EX3
    execute <<-EOSQL.squish
      CREATE UNIQUE INDEX allow_single_non_cancelled_candidate_per_student_number
      ON candidates (student_number)
      WHERE cancelled IS NOT TRUE;
    EOSQL
  end
end
