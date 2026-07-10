class RemoveSecondaryAdvocateIdFromElectoralAlliances < ActiveRecord::Migration[8.0]
  def change
    # Unused since 2012.
    remove_foreign_key :electoral_alliances, column: :secondary_advocate_id
    remove_column :electoral_alliances, :secondary_advocate_id, :integer
  end
end
