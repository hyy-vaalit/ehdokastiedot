class AddUniqueIndexToVotingArea < ActiveRecord::Migration
  def change
    add_index "voting_areas", ["code"], :name => "index_unique_voting_area_code", :unique => true
  end
end
