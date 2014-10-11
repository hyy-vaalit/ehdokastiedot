class AddExtentToVoter < ActiveRecord::Migration
  def change
    add_column :voters, :extent_of_studies, :integer
  end
end
