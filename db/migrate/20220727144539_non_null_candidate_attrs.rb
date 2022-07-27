class NonNullCandidateAttrs < ActiveRecord::Migration[6.1]
  def change
    change_column_null :candidates, :lastname, false
    change_column_null :candidates, :firstname, false
    change_column_null :candidates, :candidate_name, false
    change_column_null :candidates, :email, false
    change_column_null :candidates, :electoral_alliance_id, false
    change_column_null :candidates, :cancelled, false
    change_column_null :candidates, :numbering_order, false
  end
end
