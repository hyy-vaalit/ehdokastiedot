class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|

      t.timestamps
    end

    create_table :coalition_proportionals do |t|
      t.references :candidate
      t.references :result

      t.timestamps
    end

    create_table :alliance_proportionals do |t|
      t.references :candidate
      t.references :result

      t.timestamps
    end

    add_foreign_key(:coalition_proportionals, :candidates)
    add_foreign_key(:coalition_proportionals, :results)

    add_foreign_key(:alliance_proportionals, :candidates)
    add_foreign_key(:alliance_proportionals, :results)
  end

  def self.down
    drop_table :results
    drop_table :coalition_proportionals
    drop_table :alliance_proportionals
  end
end
