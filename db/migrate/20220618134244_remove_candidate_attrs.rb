class RemoveCandidateAttrs < ActiveRecord::Migration[6.1]
  def change
    change_table :candidates do |t|
      t.remove :social_security_number
      t.string :student_number, null: false, unique: true
    end
  end
end
