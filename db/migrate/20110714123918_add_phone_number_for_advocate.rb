class AddPhoneNumberForAdvocate < ActiveRecord::Migration
  def self.up
    change_table :advocates do |t|
      t.string :phone
    end
  end

  def self.down
    change_table :advocates do |t|
      t.remove :phone
    end
  end
end
