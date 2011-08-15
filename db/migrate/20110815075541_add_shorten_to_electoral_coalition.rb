class AddShortenToElectoralCoalition < ActiveRecord::Migration
  def self.up
    add_column :electoral_coalitions, :shorten, :string
  end

  def self.down
    remove_column :electoral_coalitions, :shorten
  end
end
