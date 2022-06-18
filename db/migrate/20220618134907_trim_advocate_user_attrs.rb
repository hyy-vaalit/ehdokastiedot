class TrimAdvocateUserAttrs < ActiveRecord::Migration[6.1]
  def change
    change_table :advocate_users do |t|
      t.remove :ssn
      t.string :student_number, null: false
      t.remove :postal_address
      t.remove :postal_code
      t.remove :postal_city
    end
  end
end
