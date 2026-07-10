class AddUniqueIndexToAdvocateStudentNumber < ActiveRecord::Migration[8.0]
  def change
    # Haka login resolves advocates by student_number; the model-only
    # uniqueness validation is race-prone without this index.
    add_index :advocate_users, :student_number, unique: true
  end
end
