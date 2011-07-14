class CreateAdvocates < ActiveRecord::Migration
  def self.up
    create_table :advocates do |t|
      t.string :lastname
      t.string :firstname
      t.string :social_security_number
      t.string :address
      t.string :postal_information
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :advocates
  end
end
