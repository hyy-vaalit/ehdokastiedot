class RemoveUnusedDeviseAttrsFromAdvocateUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :advocate_users, :reset_password_token
    remove_column :advocate_users, :reset_password_sent_at
    remove_column :advocate_users, :remember_created_at
    remove_column :advocate_users, :sign_in_count
    remove_column :advocate_users, :current_sign_in_ip
    remove_column :advocate_users, :last_sign_in_ip
  end
end
