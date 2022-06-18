class TrimAdminUserAttrs < ActiveRecord::Migration[6.1]
  def change
    change_column_null :admin_users, :role, false
  end
end
