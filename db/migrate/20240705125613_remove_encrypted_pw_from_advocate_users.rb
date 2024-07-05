class RemoveEncryptedPwFromAdvocateUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :advocate_users, :encrypted_password
  end
end
