class AddInProcessToResult < ActiveRecord::Migration
  def self.up
    change_table :results do |t|
      t.boolean :in_process, :default => false, :null => false
    end
  end

  def self.down
    change_table :results do |t|
      t.remove :in_process
    end
  end
end
