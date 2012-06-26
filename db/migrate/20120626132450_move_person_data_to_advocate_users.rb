class MovePersonDataToAdvocateUsers < ActiveRecord::Migration
  def self.up
    change_table(:advocate_users) do |t|
      t.string :firstname
      t.string :lastname
      t.string :postal_address
      t.string :postal_code
      t.string :postal_city
      t.string :phone_number
    end

    change_table(:electoral_alliances) do |t|
      t.remove   "primary_advocate_lastname"
      t.remove   "primary_advocate_firstname"
      t.remove   "primary_advocate_social_security_number"
      t.remove   "primary_advocate_address"
      t.remove   "primary_advocate_postal_information"
      t.remove   "primary_advocate_phone"
      t.remove   "primary_advocate_email"
      t.remove   "secondary_advocate_lastname"
      t.remove   "secondary_advocate_firstname"
      t.remove   "secondary_advocate_social_security_number"
      t.remove   "secondary_advocate_address"
      t.remove   "secondary_advocate_postal_information"
      t.remove   "secondary_advocate_phone"
      t.remove   "secondary_advocate_email"

      t.integer :primary_advocate_id
      t.integer :secondary_advocate_id

      t.foreign_key :advocate_users, column: 'primary_advocate_id'
      t.foreign_key :advocate_users, column: 'secondary_advocate_id'
    end

  end

  def self.down
    change_table(:advocate_users) do |t|
      t.remove :firstname
      t.remove :lastname
      t.remove :postal_address
      t.remove :postal_code
      t.remove :postal_city
      t.remove :phone_number
    end

    change_table(:electoral_alliances) do |t|
      t.string   "primary_advocate_lastname"
      t.string   "primary_advocate_firstname"
      t.string   "primary_advocate_social_security_number"
      t.string   "primary_advocate_address"
      t.string   "primary_advocate_postal_information"
      t.string   "primary_advocate_phone"
      t.string   "primary_advocate_email"
      t.string   "secondary_advocate_lastname"
      t.string   "secondary_advocate_firstname"
      t.string   "secondary_advocate_social_security_number"
      t.string   "secondary_advocate_address"
      t.string   "secondary_advocate_postal_information"
      t.string   "secondary_advocate_phone"
      t.string   "secondary_advocate_email"

      t.remove :primary_advocate_id
      t.remove :secondary_advocate_id
    end
  end
end
