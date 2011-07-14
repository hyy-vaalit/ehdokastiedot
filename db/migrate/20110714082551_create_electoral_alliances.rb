class CreateElectoralAlliances < ActiveRecord::Migration
  def self.up
    create_table :electoral_alliances do |t|
      t.string :name
      t.integer :delivered_candidate_form_amount
      t.integer :primary_advocate_id
      t.integer :secondary_advocate_id
      t.boolean :secretarial_freeze
      t.integer :electoral_circle_id
      t.integer :signing_order
      t.timestamps
    end
  end

  def self.down
    drop_table :electoral_alliances
  end
end
