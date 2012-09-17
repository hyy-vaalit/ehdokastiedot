class AddPublishedToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :published,         :boolean, :null=>false, :default=>false
    add_column :results, :published_pending, :boolean, :null=>false, :default=>false
  end

  def self.down
    remove_column :results, :published
    remove_column :results, :published_pending
  end
end
