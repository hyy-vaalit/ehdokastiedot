class RenameCandidateSignUpOrder < ActiveRecord::Migration
  def self.up
    rename_column :candidates,           :sign_up_order, :numbering_order
    rename_column :electoral_alliances,  :signing_order, :numbering_order
    rename_column :electoral_coalitions, :number_order,  :numbering_order
  end

  def self.down
    rename_column :candidates,           :numbering_order, :sign_up_order
    rename_column :electoral_alliances,  :numbering_order, :signing_order
    rename_column :electoral_coalitions, :numbering_order, :number_order
  end
end
