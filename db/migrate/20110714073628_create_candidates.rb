class CreateCandidates < ActiveRecord::Migration
  def self.up
    create_table :candidates do |t|
      t.string :firstname
      t.string :lastname
      t.string :nickname
      t.string :candidate_name
      t.string :social_security_number
      t.integer :faculty_id
      t.string :address
      t.string :postal_information
      t.string :email
      t.integer :electoral_alliance_id
      t.integer :candidate_number
      t.text :notes
      t.integer :sign_up_order
      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end
