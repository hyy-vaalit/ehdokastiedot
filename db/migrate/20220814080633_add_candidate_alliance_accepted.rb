class AddCandidateAllianceAccepted < ActiveRecord::Migration[7.0]
  def change
    add_column :candidates, :alliance_accepted, :boolean, null: false, default: false
  end
end
