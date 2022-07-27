class AddCandidateCancelledAt < ActiveRecord::Migration[6.1]
  def change
    add_column :candidates, :cancelled_at, :datetime
  end
end
