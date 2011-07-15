class MoveAdvocateDataToElectoralAllianceTableInsteadOfOwnTable < ActiveRecord::Migration
  def self.up
    change_table :electoral_alliances do |t|
      t.remove :primary_advocate_id
      t.string :primary_advocate_lastname
      t.string :primary_advocate_firstname
      t.string :primary_advocate_social_security_number
      t.string :primary_advocate_address
      t.string :primary_advocate_postal_information
      t.string :primary_advocate_phone
      t.string :primary_advocate_email

      t.remove :secondary_advocate_id
      t.string :secondary_advocate_lastname
      t.string :secondary_advocate_firstname
      t.string :secondary_advocate_social_security_number
      t.string :secondary_advocate_address
      t.string :secondary_advocate_postal_information
      t.string :secondary_advocate_phone
      t.string :secondary_advocate_email
    end
  end

  def self.down
    change_table :electoral_alliances do |t|
      t.integer :primary_advocate_id
      t.remove :primary_advocate_lastname
      t.remove :primary_advocate_firstname
      t.remove :primary_advocate_social_security_number
      t.remove :primary_advocate_address
      t.remove :primary_advocate_postal_information
      t.remove :primary_advocate_phone
      t.remove :primary_advocate_email

      t.integer :secondary_advocate_id
      t.remove :secondary_advocate_lastname
      t.remove :secondary_advocate_firstname
      t.remove :secondary_advocate_social_security_number
      t.remove :secondary_advocate_address
      t.remove :secondary_advocate_postal_information
      t.remove :secondary_advocate_phone
      t.remove :secondary_advocate_email
    end
  end
end
