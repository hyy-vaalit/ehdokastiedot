class AddEnqueuedAtToEmails < ActiveRecord::Migration
  def self.up
    change_table :emails do |t|
      t.datetime :enqueued_at
    end

  end

  def self.down
    change_table :emails do |t|
      t.remove :enqueued_at
    end
  end

end
