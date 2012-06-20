class AddDeviseToAdvocateUsers < ActiveRecord::Migration
  def self.up
    change_table(:advocate_users) do |t|
      remove_column :advocate_users, :email
      remove_column :advocate_users, :encrypted_password
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end

    add_index :advocate_users, :email,                :unique => true
    add_index :advocate_users, :reset_password_token, :unique => true
    # add_index :advocate_users, :confirmation_token,   :unique => true
    # add_index :advocate_users, :unlock_token,         :unique => true
    # add_index :advocate_users, :authentication_token, :unique => true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
