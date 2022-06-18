class AddAllianceInviteCode < ActiveRecord::Migration[6.1]
  def change
    add_column :electoral_alliances, :invite_code, :string, null: false

    add_index :electoral_alliances, :invite_code, unique: true
  end
end
