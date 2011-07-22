class AddNumberOrderToElectoralCoalition < ActiveRecord::Migration
  def self.up
    add_column :electoral_coalitions, :number_order, :integer
  end

  def self.down
    remove_column :electoral_coalitions, :number_order
  end
end
