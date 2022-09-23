class AllowNullCandidateNumberingOrder < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:candidates, :numbering_order, true)
  end
end
