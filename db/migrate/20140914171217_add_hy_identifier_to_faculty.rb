class AddHyIdentifierToFaculty < ActiveRecord::Migration
  def change
    add_column :faculties, :numeric_code, :int, :null => false
  end
end
