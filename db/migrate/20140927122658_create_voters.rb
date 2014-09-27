class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.string :name, :null => false
      t.string :student_number, :null => false
      t.string :ssn, :null => false
      t.integer :start_year
      t.timestamp :voted_at

      t.references :voting_area
      t.references :faculty, :null => false

      t.timestamps
    end

    add_foreign_key :voters, :faculties
    add_foreign_key :voters, :voting_areas

    add_index :voters, :ssn, :unique => true
    add_index :voters, :student_number, :unique => true
  end
end
