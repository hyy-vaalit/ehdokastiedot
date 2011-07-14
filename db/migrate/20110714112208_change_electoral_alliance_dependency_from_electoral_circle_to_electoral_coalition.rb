class ChangeElectoralAllianceDependencyFromElectoralCircleToElectoralCoalition < ActiveRecord::Migration
  def self.up
    change_table :electoral_alliances do |t|
      t.rename :electoral_circle_id, :electoral_coalition_id
    end
  end

  def self.down
    change_table :electoral_alliances do |t|
      t.rename :electoral_coalition_id, :electoral_circle_id
    end
  end
end
