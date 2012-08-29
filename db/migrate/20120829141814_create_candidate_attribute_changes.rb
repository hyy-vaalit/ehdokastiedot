class CreateCandidateAttributeChanges < ActiveRecord::Migration
  def self.up
    create_table :candidate_attribute_changes do |t|
      t.string :attribute_name
      t.string :previous_value
      t.string :new_value

      t.integer :candidate_id

      t.timestamps
    end

    add_foreign_key(:candidate_attribute_changes, :candidates)
  end

  def self.down
    drop_table :candidate_attribute_changes
  end
end
