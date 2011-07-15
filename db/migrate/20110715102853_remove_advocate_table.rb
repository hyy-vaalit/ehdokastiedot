class RemoveAdvocateTable < ActiveRecord::Migration
  def self.up
    drop_table :advocates
  end

  def self.down
    create_table :advocates do |t|
      t.string :lastname
      t.string :firstname
      t.string :social_security_number
      t.string :address
      t.string :postal_information
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
