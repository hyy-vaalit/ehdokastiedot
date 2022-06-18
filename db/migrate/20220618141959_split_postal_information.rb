class SplitPostalInformation < ActiveRecord::Migration[6.1]
  def change
    change_table :candidates do |t|
      t.remove :postal_information
      t.string :postal_code
      t.string :postal_city
    end
  end
end
