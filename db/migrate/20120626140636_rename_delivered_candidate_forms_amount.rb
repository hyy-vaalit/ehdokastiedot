class RenameDeliveredCandidateFormsAmount < ActiveRecord::Migration
  def self.up
    change_table :electoral_alliances do |t|
      t.rename :delivered_candidate_form_amount, :expected_candidate_count
    end
  end

  def self.down
    change_table :electoral_alliances do |t|
      t.rename :expected_candidate_count, :delivered_candidate_form_amount
    end
  end
end
