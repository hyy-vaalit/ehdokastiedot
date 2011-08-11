class CreateAdvocateUsers < ActiveRecord::Migration
  def self.up
    create_table :advocate_users do |t|
      t.string :ssn
      t.string :email
      t.string :encrypted_password

      t.timestamps
    end
  end

  def self.down
    drop_table :advocate_users
  end
end
