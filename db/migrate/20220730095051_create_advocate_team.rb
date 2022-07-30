class CreateAdvocateTeam < ActiveRecord::Migration[7.0]
  def change
    create_table :advocate_teams do |t|
      t.string :name, null: false
      t.integer :primary_advocate_user_id, null: false, index: { unique: true }

      t.timestamps
    end

    add_column :advocate_users, :advocate_team_id, :integer, null: true
    add_foreign_key :advocate_users, :advocate_teams

    add_column :electoral_coalitions, :advocate_team_id, :integer, null: true
    add_foreign_key :electoral_coalitions, :advocate_teams

    add_foreign_key :advocate_teams, :advocate_users, column: :primary_advocate_user_id
  end
end
