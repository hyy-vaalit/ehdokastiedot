class AddPhoneNumberToCandidates < ActiveRecord::Migration
  def self.up
    change_table :candidates do |t|
      t.string :phone_number
    end
  end

  def self.down
    change_table :candidates do |t|
      t.remove :phone_number
    end
  end
end
