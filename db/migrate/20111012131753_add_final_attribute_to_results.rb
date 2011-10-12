class AddFinalAttributeToResults < ActiveRecord::Migration
  def self.up
    change_table :results do |t|
      t.boolean :final,   :null => false, :default => false
      t.boolean :freezed, :null => false, :default => false
    end
  end

  def self.down
    change_table :results do |t|
      t.remove :final
      t.remove :freezed
    end
  end
end
