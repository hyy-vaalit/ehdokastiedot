class AddShortenToElectoralAlliances < ActiveRecord::Migration
  def self.up
    add_column :electoral_alliances, :shorten, :string
  end

  def self.down
    remove_column :electoral_alliances, :shorten
  end
end
