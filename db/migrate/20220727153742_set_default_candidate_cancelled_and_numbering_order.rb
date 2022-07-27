class SetDefaultCandidateCancelledAndNumberingOrder < ActiveRecord::Migration[6.1]
  def change
    change_column_default :candidates, :cancelled, from: :null, to: false
  end
end
